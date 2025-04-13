extends Resource
class_name Stats


## All of the stats a monster can have.
##
## @tutorial: https://github.com/Maruno17/godotmon-project/wiki/Data-types#stats


## Base health point.
@export var hp : int
## Attack stat used when a Monster uses a physical Attack.
@export var physical_attack : int
## Defence stat used when a Monster is struck with a physical Attack.
@export var physical_defence : int
## Attack stat used when a Monster uses a special Attack.
@export var special_attack : int
## Defence stat used when a Monster is struck with a special Attack.
@export var special_defence : int
## Speed stat used when processing action order.
@export var speed : int
## Loyalty of the Monster when caught.
@export var loyalty : int
## TBD: Initial accuracy when starting a battle.
## @experimental
@export var accuracy : int
## TBD: Initial evasiveness when starting a battle.
## @experimental
@export var evasiveness : int
