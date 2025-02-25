class_name EvolutionCondition
extends Resource
## Generic evolution condition that is always true

enum RelationWithPrevious { AND, OR }

## Relation with previous condition
##
## When 'And', if previous was false, this condition is not evaluated and becomes false  
## When 'Or', if previous was false, this condition is evaluated and replaces overal result
@export var relation_with_previous: RelationWithPrevious

## TODO: Replace Dictionary with Monster
## Check if the condition is valid based on previous and its relation with it
func evaluate(previous: bool, monster: Dictionary) -> bool:
	if relation_with_previous == RelationWithPrevious.OR:
		return previous || _evaluate(monster)
	else:
		return previous && _evaluate(monster)

## TODO: Replace Dictionary with Monster
func _evaluate(_monster: Dictionary) -> bool:
	return true
