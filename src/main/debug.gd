extends Node


# A script used to run experiments without impacting the rest of the game's scripts.
func _ready() -> void:
	await get_tree().process_frame
	ScenesManager.add_scene("res://assets/maps/test map.tscn", ScenesManager.SceneType.WORLD)
	ScenesManager.add_scene("res://assets/templates/player.tscn", ScenesManager.SceneType.ENTITY, Vector2i(5, 5))
	
	await Main.instance.dialogue_box.set_message(
		"Instant text test: TTTzzzzzz\nzzzzzzTTTTTTTTTTT\nTTTTTTTTTTT\nTTTTTT\nTTTTT\nTTTT\nTzzz\nzzzzzzzzTTTTTTTTTTTTTTTTTTTTTTTTTTTTzzzzzzzTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTzzzzzzzzTTTTTTTTTTzTTTTTTTTTzzz",
		"Mack",
		"placeholder2.png"
	)
	await Main.instance.dialogue_box.type_message(
		"Typed test: TTTzzzzzz\nzzzzzzTTTTTTTTTTT\nTTTTTTTTTTT\nTTTTTT\nTTTTT\nTTTT\nTzzz\nzzzzzzzzTTTTTTTTTTTTTTTTTTTTTTTTTTTTzzzzzzzTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTzzzzzzzzTTTTTTTTTTzTTTTTTTTTzzz",
		"Bill",
		"placeholder.png"
	)
