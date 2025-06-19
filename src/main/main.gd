extends Node
class_name Main


## The main screen of the project. Every single world, entity and UI element will be a child of one of the nodes of this scene.[br]
## Scenes can be added or removed from it using the ScenesManager autoload.


@onready var world_parent: Node2D = $WorldParent
@onready var ui_parent: CanvasLayer = $UiParent
