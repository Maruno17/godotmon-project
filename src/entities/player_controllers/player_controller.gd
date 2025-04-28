extends Node
class_name PlayerController


## Deadzone used when determining the vector used for player movements.
const INPUT_DEADZONE : float = 0.5


var player : Player

var input_direction : Vector2


func _ready() -> void:
	if not owner is Player:
		push_error("The parent of this controller isn't a player.")
		return
	
	player = owner as Player


func _physics_process(delta: float) -> void:
	if player.player_state == player.AnimatedEntityState.TURNING:
		return
	# Moving, so continue the move
	var was_moving = false
	if player.is_moving:
		update_move(delta)
		was_moving = true
	# Standing still or a step just ended, so check for input to move the player
	if player.is_moving == false:
		process_player_input(was_moving)


func process_player_input(moved_last_update: bool = false) -> void:
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down", INPUT_DEADZONE)
	_get_direction()
	# If no directional input, idle
	if input_direction.is_zero_approx():
		player.set_state(player.AnimatedEntityState.IDLE)
		return
	input_direction = input_direction.normalized()
	# Apply directional input
	if !moved_last_update && need_to_turn(input_direction):
		player.set_state(player.AnimatedEntityState.TURNING)
		player.turn(input_direction)
	elif can_move_in_direction(input_direction):
		player.set_state(player.AnimatedEntityState.WALKING)
		player.turn(input_direction)
		move(input_direction)
	else:
		player.set_state(player.AnimatedEntityState.IDLE)

#-------------------------------------------------------------------------------

func need_to_turn(new_direction: Vector2) -> bool:
	var new_facing_direction = player.VECTOR_TO_DIRECTION[new_direction.sign()]
	return new_facing_direction != player.facing_direction


# Called by turning animations to return to the idle charset
func finished_turning() -> void:
	player.set_state(player.AnimatedEntityState.IDLE)

#-------------------------------------------------------------------------------

func can_move_in_direction(direction: Vector2) -> bool:
	# Debug "walk through anything" mode
	if OS.is_debug_build() && Input.is_action_pressed("ui_control"):
		return true
	# Collision checks
	player.ray.target_position = direction * Constants.TILE_SIZE
	player.ray.force_raycast_update()
	if player.ray.is_colliding():
		player.percent_moved_to_next_tile = 0.0
		player.move_direction = Vector2.ZERO
		return false
	return true


func move(direction: Vector2) -> void:
	player.move_start_position = player.position
	player.move_direction = direction
	set_speed_modifier()
	player.is_moving = true


func should_run() -> bool:
	return Input.is_action_pressed("ui_shift")


func set_speed_modifier(reset: bool = false) -> void:
	player.move_speed_multiplier = 1.0
	if !reset:
		if should_run():
			player.move_speed_multiplier = Constants.RUN_SPEED_MULTIPLIER
			player.set_state(player.AnimatedEntityState.RUNNING)
	player.animation_tree.set("parameters/TimeScale/scale", Constants.WALK_SPEED * player.move_speed_multiplier)


# Virtual function for classes that extend this one.
func _get_direction() -> Vector2:
	return Vector2.ZERO


# Virtual function used in the player's script
func update_move(_delta : float) -> void:
	pass
