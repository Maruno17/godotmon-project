class_name LearnableAttack
extends Resource
## Data entity describing an Attack that is automatically learnt

## ID of the attack to learn
@export var learnable_attack: StringName

## TODO: Replace Dictionary with Monster
## Verify if this attack can be learnt
func evaluate(monster: Dictionary, learning_context: Dictionary) -> bool:
	return true
