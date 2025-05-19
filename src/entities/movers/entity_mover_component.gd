extends Node2D
class_name EntityMoverComponent

## Default speed of this entity in tiles/second.
const WALK_SPEED = 4.0

signal turn_completed
signal move_completed
signal collided

var parent: CharacterBody2D
var ray: RayCast2D
var animation_tree: AnimationTree
var animation_state: AnimationNodeStateMachinePlayback
var state: StringName
var starting_position: Vector2
var facing_direction: Vector2
var moving_direction: Vector2
var moving_states: Array[StringName] = [&"Walk", &"Run"]
var amount_moved_to_next_tile: float;
@export var tile_amount_per_move = 1.0
var move_speed_multiplier: float;

func _ready() -> void:
	parent = get_parent()
	starting_position = parent.position
	facing_direction = Vector2.DOWN
	moving_direction = Vector2.ZERO
	ray = $RayCast
	animation_tree = $AnimationTree
	animation_state = animation_tree.get(&"parameters/StateMachine/playback")
	amount_moved_to_next_tile = 0
	
	animation_tree.animation_finished.connect(animation_finished)
	animation_tree.active = true
	_set_animation_direction(facing_direction)
	set_state(&"Idle")
	_set_speed_modifier()

func set_state(new_state: StringName) -> void:
	state = new_state
	animation_state.travel(new_state)

func is_moving() -> bool:
	return moving_states.has(state)

func is_turning() -> bool:
	return state == &"Turn"

func is_idle() -> bool:
	return state == &"Idle"

func need_to_turn(direction: Vector2) -> bool:
	return direction.normalized() != facing_direction && is_idle()

func turn(direction: Vector2) -> void:
	var new_direction = direction.normalized()
	var must_turn = need_to_turn(new_direction)
	facing_direction = new_direction
	animation_tree.active = false
	_set_animation_direction(new_direction)
	if (must_turn):
		set_state(&"Turn")
	animation_tree.active = true

func move(direction: Vector2) -> void:
	if (is_idle() && can_move_in_direction(direction)):
		move_forced(direction)
	
func move_forced(direction: Vector2) -> void:
	moving_direction = direction
	starting_position = parent.position
	_set_speed_modifier()
	amount_moved_to_next_tile = 0
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
	ray.target_position = direction * Constants.TILE_SIZE / 2
	ray.force_raycast_update()

	if (ray.is_colliding()):
		collided.emit()
		return false;

	return true

# TODO: fix this reset behavior
func _set_speed_modifier(_reset = false) -> void:
	move_speed_multiplier = 1.0
	animation_tree.set(&"parameters/TimeScale/scale", WALK_SPEED * move_speed_multiplier)

func _physics_process(delta: float) -> void:
	if (!is_moving()): return

	amount_moved_to_next_tile += WALK_SPEED * move_speed_multiplier * delta
	if amount_moved_to_next_tile >= tile_amount_per_move:
		# Finished moving
		parent.position = starting_position + (moving_direction * floor(Constants.TILE_SIZE * tile_amount_per_move))
		amount_moved_to_next_tile = 0.0
		_move_finished()
	else:
		parent.position = starting_position + (moving_direction * floor(Constants.TILE_SIZE * amount_moved_to_next_tile))

func _move_finished() -> void:
	moving_direction = Vector2.ZERO
	_set_speed_modifier(true)
	set_state(&"Idle")
	move_completed.emit()

func _set_animation_direction(new_direction: Vector2) -> void:
	animation_tree.set(&"parameters/StateMachine/Idle/blend_position", new_direction)
	animation_tree.set(&"parameters/StateMachine/Turn/blend_position", new_direction)
	animation_tree.set(&"parameters/StateMachine/Walk/blend_position", new_direction)
