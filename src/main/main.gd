extends Node
class_name Main

## The main screen of the project. Every single world, entity and UI element will be a child of one of the nodes of this scene.[br]
## Scenes can be added or removed from it using the ScenesManager autoload.

@onready var world_parent: Node2D = $WorldParent

## UI
@onready var ui_parent: CanvasLayer = $UiParent
@onready var dialogue_box:DialogueBox = %DialogueBox

## Allows you to reference this node kinda like an autoload by just doing Main.instance.whatever_you_want_here()
static var instance:Main

func _init():
	instance = self
