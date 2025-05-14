extends Resource
class_name SkillDistribution


## The three skills a monster can have.
##
## The distribution of skill the monster can have when it's generated.[br]
## This data is also used when Skill must be change (due to any kind of effect in game).
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#skilldistribution


## ID of the common skill.
@export var common : StringName

## ID of the rare skill.
@export var rare : StringName

## ID of the hidden skill.
@export var hidden : StringName
