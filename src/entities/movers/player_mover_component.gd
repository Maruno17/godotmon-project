extends EntityMoverComponent
class_name PlayerMoverComponent

## Running speed of this entity, as a multiplier of WALK_SPEED.
const RUN_SPEED_MULTIPLIER = 2.0

var _controller: PlayerControllerBase

func _ready() -> void:
	_controller = $Controller
	super ()

func _physics_process(delta: float) -> void:
	if (is_idle()):
		_process_player_input()

	super (delta)
	

func _process_player_input() -> void:
	_controller.update()
	var input_direction = _controller.current_direction

	if (input_direction.is_zero_approx()): return

	if (need_to_turn(input_direction)):
		turn(input_direction)
	else:
		move(input_direction)

func can_move_in_direction(direction: Vector2) -> bool:
	# Debug "walk through anything" mode
	if (_controller.ghost_movement_requested): return true

	return super (direction)

func _get_move_state() -> StringName:
	if (_controller.running_requested): return &"Run"

	return super ()

func _move_finished() -> void:
	_controller.update()
	var direction = _controller.current_direction
	if (direction.is_zero_approx() || !can_move_in_direction(direction)): return super ()

	move_completed.emit()
	move_forced(direction)

func _set_speed_modifier(reset = false) -> void:
	if _controller.running_requested && !reset:
		_move_speed_multiplier = RUN_SPEED_MULTIPLIER
		_animation_tree.set(&"parameters/TimeScale/scale", WALK_SPEED * _move_speed_multiplier)
	else:
		super ()


func _set_animation_direction(new_direction: Vector2) -> void:
	super (new_direction)
	_animation_tree.set(&"parameters/StateMachine/Run/blend_position", new_direction)
