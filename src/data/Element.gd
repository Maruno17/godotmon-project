class_name Element
extends Resource
## Element of Attack or Species.
##
## Used to give strengths and weaknesses to actors and enemies in battle.

## ID of the element so it can be used as a reference to the element in each data entity that needs to refer to it.
@export var id: StringName

## List of references to element of Monster that gets x2 damages when an attack of this element is used.
@export var strong_against: Array[StringName]

## List of references to element of Monster that gets x0.5 damages when an attack of this element is used.
@export var weak_against: Array[StringName]

func _init(name := &"neutral"):
	self.name = name
	self.strongAgainst = []
	self.weakAgainst = []

## Get the damage factor when an Attack of this element hits other_element_id
func get_factor(other_element_id: StringName) -> float:
	if strong_against.has(other_element_id):
		return 2
	if weak_against.has(other_element_id):
		return 0.5
	
	return 1
