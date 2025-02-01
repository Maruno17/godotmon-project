extends CharacterBody2D

# Default speed of this entity in tiles/second.
var walk_speed: float = 4.0
# Running speed of this entity, as a multiplier of its walk_speed.
var RUN_SPEED_MULTIPLIER: float = 2.0
const TILE_SIZE: int = 16

@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/StateMachine/playback")
@onready var ray = $RayCast2D

enum PlayerState { IDLE, TURNING, WALKING, RUNNING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

# Variables relating to the player moving
var initial_position = Vector2(0, 0)
var move_direction = Vector2(0, 0)
var move_speed_multiplier = 1.0
var is_moving = false
var percent_moved_to_next_tile = 0.0

#-------------------------------------------------------------------------------

func _ready() -> void:
	anim_tree.active = true
	set_state(PlayerState.IDLE)
	initial_position = position
	turn(direction_to_vector(facing_direction))

#-------------------------------------------------------------------------------

func _physics_process(delta: float) -> void:
	if player_state == PlayerState.TURNING:
		return
	if is_moving == false:
		# If standing still, check for input to move the player
		process_player_input()
	else:
		# If moving, continue the move
		update_move(delta)
		# If a step just ended, check for another step (for continuous movement)
		if is_moving == false:
			process_player_input(true)

func process_player_input(was_moving: bool = false) -> void:
	# Detect directional input
	var input_direction = Vector2.ZERO
	input_direction.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.get_action_strength("ui_down")) - int(Input.get_action_strength("ui_up"))

	if input_direction == Vector2.ZERO:
		set_state(PlayerState.IDLE)
		return

	# Apply directional input
	if !was_moving && need_to_turn(input_direction):
		set_state(PlayerState.TURNING)
		turn(input_direction)
	elif can_move_in_direction(input_direction):
		set_state(PlayerState.WALKING)
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
	ray.target_position = direction * TILE_SIZE / 2
	ray.force_raycast_update()
	if ray.is_colliding():
		percent_moved_to_next_tile = 0.0
		move_direction = Vector2.ZERO
		return false
	return true

func move(direction: Vector2) -> void:
	turn(direction)
	initial_position = position
	move_direction = direction
	set_speed_modifier()
	is_moving = true

func update_move(delta: float) -> void:
	# Move forward
	percent_moved_to_next_tile += walk_speed * move_speed_multiplier * delta
	if percent_moved_to_next_tile >= 1.0:
		# Finished moving
		position = initial_position + (move_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		move_direction = Vector2.ZERO
		set_speed_modifier(true)
		is_moving = false
	else:
		position = initial_position + (move_direction * TILE_SIZE * percent_moved_to_next_tile)

func should_run() -> bool:
	return Input.is_action_pressed("ui_shift")

func set_speed_modifier(reset: bool = false) -> void:
	move_speed_multiplier = 1.0
	if !reset:
		if should_run():
			move_speed_multiplier = RUN_SPEED_MULTIPLIER
			set_state(PlayerState.RUNNING)
	anim_tree.set("parameters/TimeScale/scale", walk_speed * move_speed_multiplier)

#-------------------------------------------------------------------------------

func set_state(new_state: PlayerState) -> void:
	player_state = new_state
	if player_state == PlayerState.IDLE:
		anim_state.travel("Idle")
	elif player_state == PlayerState.TURNING:
		anim_state.travel("Turn")
	elif player_state == PlayerState.WALKING:
		anim_state.travel("Walk")
	elif player_state == PlayerState.RUNNING:
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
	if direction == FacingDirection.LEFT:
		vector.x = -1
	elif direction == FacingDirection.RIGHT:
		vector.x = 1
	elif direction == FacingDirection.UP:
		vector.y = -1
	elif direction == FacingDirection.DOWN:
		vector.y = 1
	return vector
