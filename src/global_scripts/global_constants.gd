extends RefCounted
class_name Constants


## The constants used all across your game.[br]
## If a constant isn't found their, then it may be script specific or handled differently (using
## resources for example). 


#region OVERWORLD

## The various mode of movements for the overworld entities.
enum MovementMode {
	## Entities can move vertically and horizontally on a grid whose size is determined by the [constant TILE_SIZE] constant. 
	GRID_4,
	## Entities can move vertically, horizontally and diagonally on a grid whose size is determined by the [constant TILE_SIZE] constant. 
	GRID_8,
	## Entities can move freely in every direction.
	FREE
	}
const MOVEMENT_MODE : MovementMode = MovementMode.GRID_4
## Size of a tile in pixels. Assumes tiles are square.
const TILE_SIZE : int = 16
## The default speed of overworld entities in tiles per seconds.[br]
## If the [constant MOVEMENT_MODE] is grid based, this value represents how many tiles are travelled in one seconds.[br]
## If the [constant MOVEMENT_MODE] is free, it is instead the amount of pixels travelled each frames, multiplied by
## the delta value of the [method Node._physics_process] function.
const WALK_SPEED : int = 4
## Running speed of this entity, as a multiplier of WALK_SPEED.
const RUN_SPEED_MULTIPLIER : int = 2

#endregion

#region MONSTERS

## Enum describing all the possible gender generation rates.
enum FemaleRate {
ASEXUAL,
MALE_ONLY,
FEMALE_12_5,
FEMALE_25,
FEMALE_37_5,
FEMALE_62_5,
FEMALE_75,
FEMALE_87_5,
FEMALE_ONLY
}

#endregion

#region MOVES

## Enum describing which target a move can reach.
enum AttackTarget {
	## The user of the move.
	SELF,
	## A monster close to the user.
	ONE_ADJACENT,
	## Every monster on the battlefield except for the user.
	EVERYONE_ASIDE_SELF,
	## Every monster on the battlefield.
	EVERYONE,
	## Every monster on the opponent's side.
	ENEMY_SIDE,
	## Every monster on the user's side, except for the user itself.
	ALLY_SIDE_ASIDE_SELF,
	## Every monster on the user's side, including the user itself.
	ALLY_SIDE,
	## A random monster close to the user.
	RANDOM_ADJACENT,
	## A random monster that isn't the user.
	RANDOM_ASIDE_SELF
}

## Each move comes with one of the following categories. They are used in the damage calculation of
## an attack.
enum MoveCategory {
	## Damaging moves where the user makes direct contact with the target like a punch or a bite.
	DIRECT,
	## Damaging moves where the user affects the target without being physically in contact with it
	## like with a projectile or a laser beam.
	INDIRECT,
	## Moves where the target doesn't take damage.
	OTHER
}

#endregion
