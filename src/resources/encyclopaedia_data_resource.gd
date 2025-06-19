extends Resource
class_name EncyclopaediaData


## Describe the content of an Encyclopaedia a Player could have.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#encyclopaediadata


## First ID shown in the encyclopaedia.
@export var start_id : int = 1

## ID of all the monsters in this Encyclopaedia (by appearance order).
@export var monsters : Array[StringName]
