class_name MonsterData
extends Resource
## Generic information about a potential Monster.
##
## Should be used by both Encyclopaedia and Monster.

enum GrowRate {
	FAST,
	NORMAL,
	SLOW,
	PARABOLIC,
	ERRATIC,
	FLUCTUATING
}

## ID of the monster. For form support, you should write things like SLIME_DEFAULT or SLIME_FIRE
@export var id: StringName

## Specie of the monster (allowing to group each forms together)
@export var specie: StringName

## Elements of the monster
@export var elements: Array[StringName]

## All the base statistics of the monster (scaled by level)
@export var base_stats: Stats

## All the statistic points distributed when defeated
@export var stat_rewards: StatRewards

## Experience reward given (adjusted for the level diff) when defeated
@export_range(1, 0xFFFFFFFF) var experience_reward: int

## All the evolutions a monster can have based on internal conditions to be met
@export var evolutions: Array[Evolution]

## Type of grow rate (experience -> level)
@export var grow_rate: GrowRate

## All the breeding related data (groups, hatch steps, female rate, baby when breeding)
@export var breeding: Breeding

## All the possible skills the monster can have (based on some conditions)
@export var skills: SkillDistribution

## All the attacks the monster can learn while growing or for other reasons
@export var learnable_attacks: Array[LearnableAttack]

## All the resource used to represent the monster in various situation (battler, cry, etc...)
@export var resource: MonsterResources

@export_group("Extra")
## Weight of the monster (TBD: can it be a stat?)
@export var weight: float

## Height of the monster (TBD: can it be a stat?)
@export var height: float
