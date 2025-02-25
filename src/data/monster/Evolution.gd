class_name Evolution
extends Resource
## Condition that makes the Monster evolve into another Monster

## ID of the MonsterData the Monster would evolve to if conditions are met
@export var evolve_to: StringName

## List of condition for the Monster to be able to evolve
@export var conditions: Array[EvolutionCondition]
