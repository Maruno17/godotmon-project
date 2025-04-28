extends CharacterBody2D
class_name Entity


## The basic node used to create moving entities.
##
## Let you create entities that can go to specific coordinates, or move relatively to their current position.[br]
## If you want your entity to be animated, use [AnimatedEntity] instead.
##
## @tutorial: TODO


enum State { IDLE, MOVING }


var state : State = State.IDLE
var is_moving : bool = false
var move_start_position : Vector2 = Vector2.ZERO
var move_direction : Vector2 = Vector2.ZERO
var move_speed_multiplier : float = 1.0
var percent_moved_to_next_tile : float = 0.0


## Move the entity to the specified coordinates.
@warning_ignore("unused_parameter")
func move_to_coordinates(coordinates : Vector2, speed : int = Constants.WALK_SPEED) -> void:#TODO
	match Constants.MOVEMENT_MODE:
		Constants.MovementMode.GRID_4:
			pass
		Constants.MovementMode.GRID_8:
			pass
		Constants.MovementMode.FREE:
			pass


## Move the entity by a certain amount of pixels relative to its current position.[br]
## For example, [code]pixels_move_from_current(Vector2(58,-25)[/code] will make your entity move 58
## pixels to the right and 25 pixels up.
@warning_ignore("unused_parameter")
func pixels_move_from_current(vector : Vector2, speed : int = Constants.WALK_SPEED) -> void:#TODO
	match Constants.MOVEMENT_MODE:
		Constants.MovementMode.GRID_4:
			pass
		Constants.MovementMode.GRID_8:
			pass
		Constants.MovementMode.FREE:
			pass


## Move the entity by a certain amount of tiles relative to its current position.[br]
## For example, [code]tiles_move_from_current(Vector2(-3,7)[/code] will make your entity move 3 tiles
## to the left and 7 tiles down.
@warning_ignore("unused_parameter")
func tiles_move_from_current(tiles_amount : Vector2, speed : int = Constants.WALK_SPEED) -> void:#TODO
	match Constants.MOVEMENT_MODE:
		Constants.MovementMode.GRID_4:
			pass
		Constants.MovementMode.GRID_8:
			pass
		Constants.MovementMode.FREE:
			pass
