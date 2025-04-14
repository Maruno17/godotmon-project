extends Node


# A script used to run experiments without impacting the rest of the game's scripts.


func _ready() -> void:
	await get_tree().process_frame
	ScenesManager.add_scene("res://assets/maps/test map.tscn", ScenesManager.SceneType.WORLD)
	ScenesManager.add_scene("res://assets/templates/player.tscn", ScenesManager.SceneType.ENTITY, Vector2i(5, 5))
	
	await get_tree().create_timer(2).timeout
	DialogBox.show_message("Test of the [wave amp=20.0 freq=5.0 connected=1][rainbow freq=1.0 sat=0.8 val=0.8]Message Box[/rainbow][/wave] using [b][bgcolor=blue][color=red]BBCode[/color][/bgcolor][/b].")
	await DialogBox.message_closed
	DialogBox.show_message("Yes, using BBCode makes it so that less characters are displayed, I haven't found a way to fix that yet but I'll be working on it.", "Sulucnal")
	await DialogBox.message_closed
	DialogBox.show_message("test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test")
	await DialogBox.message_closed
	DialogBox.show_message("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20")
	await DialogBox.message_closed
	DialogBox.show_message("Test of a message with a talker name.", "Random person")
	await DialogBox.message_closed
	DialogBox.show_message("Test of a message with a talker name and a portrait.", "Prof. Godot", "res://assets/ui/dialog/portraits/prof_godot.png")
