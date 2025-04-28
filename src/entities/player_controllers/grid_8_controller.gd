extends PlayerController
class_name Grid8Controller


# BUG: Diagonal movements get desynchronized with the grid.


func _get_direction() -> Vector2:
	if input_direction != Vector2.ZERO:
		player.last_direction = input_direction
	
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
		player.set_speed_modifier(true)
		player.is_moving = false
	else:
		player.position = player.move_start_position + (player.move_direction * Constants.TILE_SIZE * player.percent_moved_to_next_tile)
