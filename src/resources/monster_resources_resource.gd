extends Resource
class_name MonsterResources


## All the resource tied to a Monster so it can be shown properly anywhere needed.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#monsterresources


## Path to the image for the front sprite
@export_file("*.png", "*.gif") var front : String
## Path to the image for the back sprite
@export_file("*.png", "*.gif") var back : String
## Path to the image for the icon in menu
@export_file("*.png", "*.gif") var icon : String
## Path to the sound effect for the cry of the Monster
@export_file(".wav", ".ogg", ".mp3") var cry : String
## Record of special resource that might be checked under certain condition (eg. female sprite).
@export var conditional_resources : Dictionary[String, String]
