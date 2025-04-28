extends AnimatedEntity
class_name Player


##The player scene and all of the logic behind it.
##
## @tutorial: TODO

@onready var ray : RayCast2D = $RayCast2D


var player_state : AnimatedEntityState = AnimatedEntityState.IDLE
