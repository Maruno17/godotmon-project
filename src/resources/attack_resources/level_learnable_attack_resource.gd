extends LearnableAttack
class_name LevelLearnableAttack


## Data entity describing an Attack that is learnt at a certain level.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#levellearnableattack-extends-learnableattack


## Level when the attack is learnt
@export_range(1, Constants.MAX_LEVEL) var level : int
