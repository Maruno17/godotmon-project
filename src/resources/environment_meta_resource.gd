extends Resource
class_name EnvironmentMeta


## Living object describing all the information about the environment the player is in.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#environmentmeta


## ID of the world the player is in (overworld, indoor, etc...).
@export var world_id : StringName

## Name of the world variant (for seasonal purpose or scenario related purpose).
@export var variant : StringName

## Position of the player in the world.
@export var position : Vector2

## ID of the weather the player is currently seeing.
@export var weather : StringName
