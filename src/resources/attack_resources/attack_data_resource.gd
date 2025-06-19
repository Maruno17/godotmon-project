extends Resource
class_name AttackData


## Data entity describing an Attack a Monster can use.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#attackdata


## ID of the attack.
@export var id : StringName

## ID of the element of this attack.
@export var element_id : StringName

## base power of the attack (0 = no damage).
@export_range(0,9999) var power : int

## base accuracy of the attack (0 = always hit without check).
@export_range(0,100) var accuracy : int

## Number of time the attack can be used.
@export_range(1, 9999) var use_count : int

## target the move reach when used.
@export var target : Constants.AttackTarget
