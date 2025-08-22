extends Node2D

func _ready() -> void:
	ScenesManager.add_scene("res://assets/templates/event001.tscn", ScenesManager.SceneType.ENTITY, Vector2i(4, 5))
