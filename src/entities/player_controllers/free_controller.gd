extends PlayerController
class_name FreeController


func _get_direction() -> Vector2:
	if input_direction != Vector2.ZERO:
		player.last_direction = input_direction
	
	return input_direction


func update_move(delta: float) -> void:
	if !player.is_moving:
		return
	# Move forward
	player.position += input_direction * (Constants.WALK_SPEED * player.move_speed_multiplier) * delta
	player.set_speed_modifier(true)
