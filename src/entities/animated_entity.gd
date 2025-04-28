extends Entity
class_name AnimatedEntity


## Node used to create moving animated entities.
##
## Let you create entities that can go to specific coordinates, or move relatively to their current position.[br]
## If they are simple enough and use the default , they can be easily animated by providing the appropriate
## [animation_player] and [animation_tree].
##
## @tutorial: TODO


const VECTOR_TO_DIRECTION : Dictionary[Vector2, FacingDirection] = {
	Vector2(-1,-1) : FacingDirection.UP_LEFT,
	Vector2(-1,0) : FacingDirection.LEFT,
	Vector2(-1,1) : FacingDirection.DOWN_LEFT,
	Vector2(0,-1) : FacingDirection.UP,
	Vector2(0,1) : FacingDirection.DOWN,
	Vector2(1,-1) : FacingDirection.UP_RIGHT,
	Vector2(1,0) : FacingDirection.RIGHT,
	Vector2(1,1) : FacingDirection.DOWN_RIGHT
}


const DIRECTION_TO_VECTOR : Dictionary[FacingDirection, Vector2] = {
	FacingDirection.UP_LEFT : Vector2(-1,-1),
	FacingDirection.LEFT : Vector2(-1,0),
	FacingDirection.DOWN_LEFT : Vector2(-1,1),
	FacingDirection.UP : Vector2(0,-1),
	FacingDirection.DOWN : Vector2(0,1),
	FacingDirection.UP_RIGHT : Vector2(1,-1),
	FacingDirection.RIGHT : Vector2(1,0),
	FacingDirection.DOWN_RIGHT : Vector2(1,1)
}


enum AnimatedEntityState { IDLE, TURNING, WALKING, RUNNING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN, UP_LEFT, DOWN_LEFT, UP_RIGHT, DOWN_RIGHT }


@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@onready var animation_state : AnimationNodeStateMachinePlayback


var animated_entity_state : AnimatedEntityState = AnimatedEntityState.IDLE
var facing_direction : FacingDirection = FacingDirection.DOWN
var last_direction : Vector2 = Vector2(1,0)


func _ready() -> void:
	_set_animation_state()
	animation_tree.active = true
	set_state(AnimatedEntityState.IDLE)
	move_start_position = position
	turn(DIRECTION_TO_VECTOR[facing_direction])


func _set_animation_state() -> void:
	if animation_tree == null:
		push_error("This entity doesn't have an animation tree attributed to its animation_tree export variable.")
		return
	
	animation_state = animation_tree.get("parameters/StateMachine/playback")


func set_state(new_state: AnimatedEntityState) -> void:
	animated_entity_state = new_state
	match state:
		AnimatedEntityState.IDLE:
			animation_state.travel("Idle")
		AnimatedEntityState.TURNING:
			animation_state.travel("Turn")
		AnimatedEntityState.WALKING:
			animation_state.travel("Walk")
		AnimatedEntityState.RUNNING:
			animation_state.travel("Run")


func turn(direction: Vector2) -> void:
	facing_direction = VECTOR_TO_DIRECTION[direction.sign()]
	animation_tree.set("parameters/StateMachine/Idle/blend_position", direction)
	animation_tree.set("parameters/StateMachine/Turn/blend_position", direction)
	animation_tree.set("parameters/StateMachine/Walk/blend_position", direction)
	animation_tree.set("parameters/StateMachine/Run/blend_position", direction)
