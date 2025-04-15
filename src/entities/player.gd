extends CharacterBody2D
class_name Player


##The player scene and all of the logic behind it.


enum PlayerState { IDLE, TURNING, WALKING, RUNNING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }


## Default speed of this entity in tiles/second.
const WALK_SPEED = 4.0
## Running speed of this entity, as a multiplier of WALK_SPEED.
const RUN_SPEED_MULTIPLIER = 2.0

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN
# Variables relating to the player moving
var is_moving = false
var move_start_position = Vector2.ZERO
var move_direction = Vector2.ZERO
var move_speed_multiplier = 1.0
var percent_moved_to_next_tile = 0.0

@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/StateMachine/playback")
@onready var ray = $RayCast2D
@onready var interactions_raycast: RayCast2D = $InteractionsRaycast

#-------------------------------------------------------------------------------

func _ready() -> void:
	anim_tree.active = true
	set_state(PlayerState.IDLE)
	move_start_position = position
	turn(direction_to_vector(facing_direction))
	
	interactions_raycast.target_position.y = Constants.TILE_SIZE
	@warning_ignore("integer_division")
	interactions_raycast.position = Vector2(Constants.TILE_SIZE / 2, Constants.TILE_SIZE / 2)
	

#-------------------------------------------------------------------------------

func _physics_process(delta: float) -> void:
	if player_state == PlayerState.TURNING:
		return
	# Moving, so continue the move
	var was_moving = false
	if is_moving:
		update_move(delta)
		was_moving = true
	# Standing still or a step just ended, so check for input to move the player
	if is_moving == false:
		process_player_input(was_moving)


func process_player_input(moved_last_update: bool = false) -> void:
	# Detect directional input
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction.x != 0 and input_direction.y !=0:
		input_direction.y = 0
	
	if input_direction != Vector2.ZERO:
		interactions_raycast.target_position = input_direction.sign() * Constants.TILE_SIZE
		interactions_raycast.force_raycast_update()
	
	# If no directional input, idle
	if input_direction.is_zero_approx():
		set_state(PlayerState.IDLE)
		return
	input_direction = input_direction.normalized()
	# Apply directional input
	if !moved_last_update && need_to_turn(input_direction):
		set_state(PlayerState.TURNING)
		turn(input_direction)
	elif can_move_in_direction(input_direction):
		set_state(PlayerState.WALKING)
		turn(input_direction)
		move(input_direction)
	else:
		set_state(PlayerState.IDLE)

#-------------------------------------------------------------------------------

func need_to_turn(new_direction: Vector2) -> bool:
	var new_facing_direction = vector_to_direction(new_direction)
	return new_facing_direction != facing_direction


func turn(direction: Vector2) -> void:
	facing_direction = vector_to_direction(direction)
	anim_tree.set("parameters/StateMachine/Idle/blend_position", direction)
	anim_tree.set("parameters/StateMachine/Turn/blend_position", direction)
	anim_tree.set("parameters/StateMachine/Walk/blend_position", direction)
	anim_tree.set("parameters/StateMachine/Run/blend_position", direction)


# Called by turning animations to return to the idle charset
func finished_turning() -> void:
	set_state(PlayerState.IDLE)

#-------------------------------------------------------------------------------

func can_move_in_direction(direction: Vector2) -> bool:
	# Debug "walk through anything" mode
	if OS.is_debug_build() && Input.is_action_pressed("ui_control"):
		return true
	# Collision checks
	ray.target_position = direction * Constants.TILE_SIZE
	ray.force_raycast_update()
	if ray.is_colliding():
		percent_moved_to_next_tile = 0.0
		move_direction = Vector2.ZERO
		return false
	return true


func move(direction: Vector2) -> void:
	move_start_position = position
	move_direction = direction
	set_speed_modifier()
	is_moving = true


func update_move(delta: float) -> void:
	if !is_moving:
		return
	# Move forward
	percent_moved_to_next_tile += WALK_SPEED * move_speed_multiplier * delta
	if percent_moved_to_next_tile >= 1.0:
		# Finished moving
		position = move_start_position + (move_direction * Constants.TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		move_direction = Vector2.ZERO
		set_speed_modifier(true)
		is_moving = false
	else:
		position = move_start_position + (move_direction * Constants.TILE_SIZE * percent_moved_to_next_tile)


func should_run() -> bool:
	return Input.is_action_pressed("ui_shift")


func set_speed_modifier(reset: bool = false) -> void:
	move_speed_multiplier = 1.0
	if !reset:
		if should_run():
			move_speed_multiplier = RUN_SPEED_MULTIPLIER
			set_state(PlayerState.RUNNING)
	anim_tree.set("parameters/TimeScale/scale", WALK_SPEED * move_speed_multiplier)

#-------------------------------------------------------------------------------

func set_state(new_state: PlayerState) -> void:
	player_state = new_state
	match player_state:
		PlayerState.IDLE:
			anim_state.travel("Idle")
		PlayerState.TURNING:
			anim_state.travel("Turn")
		PlayerState.WALKING:
			anim_state.travel("Walk")
		PlayerState.RUNNING:
			anim_state.travel("Run")


func vector_to_direction(vector: Vector2) -> FacingDirection:
	var direction
	if vector.x < 0:
		direction = FacingDirection.LEFT
	elif vector.x > 0:
		direction = FacingDirection.RIGHT
	elif vector.y < 0:
		direction = FacingDirection.UP
	elif vector.y > 0:
		direction = FacingDirection.DOWN
	return direction


func direction_to_vector(direction: FacingDirection) -> Vector2:
	var vector = Vector2.ZERO
	match direction:
		FacingDirection.LEFT:
			vector.x = -1
		FacingDirection.RIGHT:
			vector.x = 1
		FacingDirection.UP:
			vector.y = -1
		FacingDirection.DOWN:
			vector.y = 1
	return vector

#-------------------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactions_raycast.is_colliding():
		interactions_raycast.get_collider().get_parent().run_interaction(self)
