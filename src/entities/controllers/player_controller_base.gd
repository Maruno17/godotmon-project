extends Node
class_name PlayerControllerBase

var current_direction: Vector2
var running_requested: bool
var ghost_movement_requested: bool

func update() -> void:
	current_direction = _get_direction(Input.get_vector("move_left", "move_right", "move_up", "move_down"))
	running_requested = _should_run();
	ghost_movement_requested = _should_walk_through_walls()

func _should_run() -> bool:
	return Input.is_action_pressed("ui_shift")

func _should_walk_through_walls() -> bool:
	return OS.is_debug_build() && Input.is_action_pressed("ui_control")

func _get_direction(_input: Vector2) -> Vector2:
	return _input
