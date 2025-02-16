extends AudioStreamPlayer


## An autoload with functions used to play/change the bgm.


## The index of the bus used to handle music[br]
## (The "Audio" tab at the bottom of the window).
const MUSIC_BUS_INDEX : int = 1


## Used in the maps script to handle transition to the bgm associated with said map.
func play_area_music(area : Area2D, transition_duration : float = 0.5) -> void:
	if not area.is_in_group("MapArea"):
		return
	
	_change_bgm(area.bgm, transition_duration)


## Plays music using their path in the file explorer as an argument.
func play_music_from_path(bgm_path : String, transition_duration : float = 0.5) -> void:
	var new_bgm : AudioStream = load(bgm_path)
	_change_bgm(new_bgm, transition_duration)


## Plays music using an audio stream as an argument.
func play_music_from_audio_stream(bgm : AudioStream, transition_duration : float = 0.5) -> void:
	_change_bgm(bgm, transition_duration)


# Handles the logic behind the transition between two musics.
func _change_bgm(new_bgm : AudioStream, transition_duration : float) -> void:
	var initial_volume : float = AudioServer.get_bus_volume_db(MUSIC_BUS_INDEX)
	
	if stream != null:
		var tween_fade_out : Tween = create_tween()
		tween_fade_out.tween_property(self, "volume_db", -80.0, transition_duration)
		await tween_fade_out.finished
		
	stream = new_bgm
	volume_db = initial_volume
	play()
