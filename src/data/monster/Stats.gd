class_name Stats
extends Resource
## All the stats a monster can have.

## Base health point
@export_range(1, 0xFF, 1, "or_greater") var hp: int

## Attack stat used when Monster use physical Attack
@export_range(1, 0xFF, 1, "or_greater") var physical_attack: int

## Defence stat used when a Monster is strike with a physical Attack
@export_range(1, 0xFF, 1, "or_greater") var physical_defence: int

## Attack stat used when Monster use special Attack
@export_range(1, 0xFF, 1, "or_greater") var special_attack: int

## Defence stat used when a Monster is strike with a special Attack
@export_range(1, 0xFF, 1, "or_greater") var special_defence: int

## Speed stat used when processing action order
@export_range(1, 0xFF, 1, "or_greater") var speed: int

## Loyalty of the Monster when caught
@export_range(0, 0xFF, 1, "or_greater") var loyalty: int

## TBD: Initial accuracy when starting a battle
@export_range(0, 0xFF, 1, "or_greater") var accuracy: int

## TBD: Initial evasiveness when starting a battle
@export_range(0, 0xFF, 1, "or_greater") var evasiveness: int
