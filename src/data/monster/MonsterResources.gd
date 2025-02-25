class_name MonsterResources
extends Resource
## All the resource tied to a Monster so it can be shown properly anywhere needed.

## Path to the image for the front sprite
@export_file("res://assets/graphics/monsters/sprites/*.png") var front: String

## Path to the image for the back sprite
@export_file("res://assets/graphics/monsters/sprites/*.png") var back: String

## Path to the image for the icon in menu
@export_file("res://assets/graphics/monsters/icons/*.png") var icon: String

## Path to the sound effect for the cry of the Monster
@export_file("res://assets/audio/cries/*.ogg") var cry: String

## Record of special resource that might be checked under certain condition (eg. female sprite).
@export var conditional_resources: Dictionary
