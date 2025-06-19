extends Node


# A script used to run experiments without impacting the rest of the game's scripts.


func _ready() -> void:
	await get_tree().process_frame
	ScenesManager.add_scene("res://assets/maps/test map.tscn", ScenesManager.SceneType.WORLD)
	ScenesManager.add_scene("res://assets/templates/player.tscn", ScenesManager.SceneType.ENTITY, Vector2i(5, 5))
	
	await get_tree().create_timer(2).timeout
	GDMUtils.grayscale_transition("uid://cdicmm4o3jggt")
	await Observer.transition_finished
	GDMUtils.grayscale_transition("uid://cdicmm4o3jggt", 0.5, true)
