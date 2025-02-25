class_name EvolutionMinLevelCondition
extends EvolutionCondition

@export_range(1, 100, 1, "or_greater") var min_level: int

## TODO: Replace Dictionary with Monster
func _evaluate(monster: Dictionary) -> bool:
	return monster.get('level', 0) >= min_level
