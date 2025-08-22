extends CharacterBody2D
class_name Event001

var _mover: EntityMoverComponent

func _ready() -> void:
	_mover = $EntityMoverComponent
	_move_init()

func _next_step_after_time(step: Callable) -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(0.25)
	timer.timeout.connect(step, CONNECT_ONE_SHOT)

func _move_init() -> void:
	_next_step_after_time(_move_step1)

func _move_step1() -> void:
	if (_mover.can_move_in_direction(Vector2.DOWN)):
		_mover.move_completed.connect(_move_step2, CONNECT_ONE_SHOT)
		_mover.move_forced(Vector2.DOWN)
	else:
		_next_step_after_time(_move_step1)
		
func _move_step2() -> void:
	_next_step_after_time(_move_step3)

func _move_step3() -> void:
	if (_mover.can_move_in_direction(Vector2.UP)):
		_mover.move_completed.connect(_move_init, CONNECT_ONE_SHOT)
		_mover.move_forced(Vector2.UP)
	else:
		_next_step_after_time(_move_step3)
