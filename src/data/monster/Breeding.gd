class_name Breeding
extends Resource
## All the breeding related information (including naturally generating Monster in the overworld)

## TBD: Maybe we should use @export_enum instead
enum FemaleRate {
	ASEXUAL,
	MALE_ONLY,
	FEMALE_12_5,
	FEMALE_25,
	FEMALE_37_5,
	FEMALE_50,
	FEMALE_62_5,
	FEMALE_75,
	FEMALE_87_5,
	FEMALE_ONLY
}

## TBD: Maybe we should use @export_flags instead
enum BreedingGroup {
	UNBREADABLE,
	ANY,
}

## List of compatibility group the Monster can breed with
@export var groups: Array[BreedingGroup]

## Number of steps required for the monster egg to hatch
@export var hatchSteps: int

## Type of female rate that naturally generate when hatching or encounter in the overworld
@export var femaleRate: FemaleRate

## ID of the monster that hatch when this monster is female in breeding
@export var baby: StringName
