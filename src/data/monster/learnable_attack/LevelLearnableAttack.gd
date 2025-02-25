class_name LevelLearnableAttack
extends LearnableAttack
## Data entity describing an Attack that is learnt at a certain level

## Level when the attack is learnt
@export var min_level: int

## TODO: Replace Dictionary with Monster
## Verify if this attack can be learnt
func evaluate(monster: Dictionary, learning_context: Dictionary) -> bool:
	return monster.get("level", 0) >= min_level
