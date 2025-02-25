class_name SkillDistribution
extends Resource
## The distribution of skill the monster can have when it's generated.
##
## This data is also used when Skill must be change (due to any kind of effect in game).

## ID of the common skill
@export var common: StringName

## ID of the rare skill
@export var rare: StringName

## ID of the hidden skill
@export var hidden: StringName
