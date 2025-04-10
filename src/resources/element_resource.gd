extends Resource
class_name Element


## Element of Attack or Species.
##
## This data type is used to define which element is strong or weak against another element in battle.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#element


## ID of the element so it can be used as a reference to the element in each data entity that needs to refer to it.
@export var id : StringName
## List of references to element of Monster that gets x2 damages when an attack of this element is used.
@export var strong_against : Array[StringName]
## List of references to element of Monster that gets x0.5 damages when an attack of this element is used.
@export var weak_against : Array[StringName]
