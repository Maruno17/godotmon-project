class_name StatRewards
extends Resource
## All the stats point that can ba added to stats when defeating a monster

## Health points added when defeating this monster
@export_range(0, 2, 1, "or_greater") var hp: int

## Attack points added when defeating this monster
@export_range(0, 2, 1, "or_greater") var physical_attack: int

## Defence points added when defeating this monster
@export_range(0, 2, 1, "or_greater") var physical_defence: int

## Attack points added when defeating this monster
@export_range(0, 2, 1, "or_greater") var special_attack: int

## Defence points added when defeating this monster
@export_range(0, 2, 1, "or_greater") var special_defence: int

## Speed points added when defeating this monster
@export_range(0, 2, 1, "or_greater") var speed: int

## Loyalty added when defeating this monster
@export_range(0, 2, 1, "or_greater") var loyalty: int
