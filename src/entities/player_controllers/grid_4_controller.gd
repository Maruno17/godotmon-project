extends PlayerController
class_name Grid4Controller


func _get_direction() -> Vector2:
	if input_direction.x != 0 and input_direction.y !=0:
		if not is_zero_approx(player.last_direction.x):
			input_direction.x = 0
		elif not is_zero_approx(player.last_direction.y) or player.last_direction == Vector2.ZERO:
			input_direction.y = 0
	elif input_direction != Vector2.ZERO:
		player.last_direction = input_direction.sign()
	
	return input_direction.sign()


func update_move(delta: float) -> void:
	if !player.is_moving:
		return
	# Move forward
	player.percent_moved_to_next_tile += Constants.WALK_SPEED * player.move_speed_multiplier * delta
	if player.percent_moved_to_next_tile >= 1.0:
		# Finished moving
		player.position = player.move_start_position + (player.move_direction * Constants.TILE_SIZE)
		player.percent_moved_to_next_tile = 0.0
		player.move_direction = Vector2.ZERO
		set_speed_modifier(true)
		player.is_moving = false
	else:
		player.position = player.move_start_position + (player.move_direction * Constants.TILE_SIZE * player.percent_moved_to_next_tile)
