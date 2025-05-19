extends Node2D
class_name EntityMoverComponent

## Default speed of this entity in tiles/second.
const WALK_SPEED = 4.0

signal turn_completed
signal move_completed
signal collided

# Dependencies
var _parent: CharacterBody2D
var _ray: RayCast2D
var _animation_tree: AnimationTree
var _animation_state: AnimationNodeStateMachinePlayback

# Internal variables
var _state: StringName
var _starting_position: Vector2
var _facing_direction: Vector2
var _moving_direction: Vector2
var _moving_states: Array[StringName] = [&"Walk", &"Run"]
var _amount_moved_to_next_tile: float;
var _move_speed_multiplier: float;

## Variable to set to the desired amount of tile per move, eg: 0.125 will allow moving 2px per move (in 16x16 grid)
@export var tile_amount_per_move = 1.0

func _ready() -> void:
	_parent = get_parent()
	_starting_position = _parent.position
	_facing_direction = Vector2.DOWN
	_moving_direction = Vector2.ZERO
	_ray = $RayCast
	_animation_tree = $AnimationTree
	_animation_state = _animation_tree.get(&"parameters/StateMachine/playback")
	_amount_moved_to_next_tile = 0
	
	_animation_tree.animation_finished.connect(animation_finished)
	_animation_tree.active = true
	_set_animation_direction(_facing_direction)
	set_state(&"Idle")
	_set_speed_modifier()

func set_state(new_state: StringName) -> void:
	_state = new_state
	_animation_state.travel(new_state)

func is_moving() -> bool:
	return _moving_states.has(_state)

func is_turning() -> bool:
	return _state == &"Turn"

func is_idle() -> bool:
	return _state == &"Idle"

func need_to_turn(direction: Vector2) -> bool:
	return direction.normalized() != _facing_direction && is_idle()

func turn(direction: Vector2) -> void:
	var new_direction = direction.normalized()
	var must_turn = need_to_turn(new_direction)
	_facing_direction = new_direction
	_animation_tree.active = false
	_set_animation_direction(new_direction)
	if (must_turn):
		set_state(&"Turn")
	_animation_tree.active = true

func move(direction: Vector2) -> void:
	if (is_idle() && can_move_in_direction(direction)):
		move_forced(direction)
	
func move_forced(direction: Vector2) -> void:
	_moving_direction = direction
	_starting_position = _parent.position
	_set_speed_modifier()
	_amount_moved_to_next_tile = 0
	_set_animation_direction(direction.normalized())
	set_state(_get_move_state())

func _get_move_state() -> StringName:
	return &"Walk"

func animation_finished(animation_name: StringName) -> void:
	if (animation_name.begins_with("Turn")):
		set_state(&"Idle")
		turn_completed.emit()

func can_move_in_direction(direction: Vector2) -> bool:
	# Collision checks
	_ray.target_position = direction * Constants.TILE_SIZE / 2
	_ray.force_raycast_update()

	if (_ray.is_colliding()):
		collided.emit()
		return false;

	return true

# TODO: fix this reset behavior (boolean params are massive red flag)
func _set_speed_modifier(_reset = false) -> void:
	_move_speed_multiplier = 1.0
	_animation_tree.set(&"parameters/TimeScale/scale", WALK_SPEED * _move_speed_multiplier)

# TODO: use a tween to avoid having so much private variables
#				Not doing it now because I don't know how to make it discreet
func _physics_process(delta: float) -> void:
	if (!is_moving()): return

	_amount_moved_to_next_tile += WALK_SPEED * _move_speed_multiplier * delta
	if _amount_moved_to_next_tile >= tile_amount_per_move:
		# Finished moving
		_parent.position = _starting_position + (_moving_direction * floor(Constants.TILE_SIZE * tile_amount_per_move))
		_move_finished()
	else:
		# Still moving
		_parent.position = _starting_position + (_moving_direction * floor(Constants.TILE_SIZE * _amount_moved_to_next_tile))

func _move_finished() -> void:
	_amount_moved_to_next_tile = 0.0
	_moving_direction = Vector2.ZERO
	_set_speed_modifier(true)
	set_state(&"Idle")
	move_completed.emit()

func _set_animation_direction(new_direction: Vector2) -> void:
	_animation_tree.set(&"parameters/StateMachine/Idle/blend_position", new_direction)
	_animation_tree.set(&"parameters/StateMachine/Turn/blend_position", new_direction)
	_animation_tree.set(&"parameters/StateMachine/Walk/blend_position", new_direction)
