extends Node

const FILEPATH = "res://assets/music/"
const DEFAULT_VOL = 0.65

@onready var music_stream_player: AudioStreamPlayer = %MusicStreamPlayer
@onready var jingle_stream_player: AudioStreamPlayer = %JingleStreamPlayer

func play_song(song_name: String):
	var last_beat: float
	var keep_pos: bool = false
	
	if song_name == "darius_defense_danger" and is_song_playing("darius_defense"):
		keep_pos = true
	elif song_name == "darius_defense" and is_song_playing("darius_defense_danger"):
		keep_pos = true
	
	if keep_pos:
		last_beat = music_stream_player.get_playback_position() * (music_stream_player.stream.bpm / 60.0)
	
	music_stream_player.stop()
	music_stream_player.volume_linear = DEFAULT_VOL
	music_stream_player.stream = load(FILEPATH + song_name + ".ogg")
	music_stream_player.play(0 if not keep_pos else last_beat / (music_stream_player.stream.bpm / 60.0))


func play_jingle(jingle_name: String):
	jingle_stream_player.stop()
	var tween := get_tree().create_tween()
	tween.tween_property(music_stream_player, "volume_linear", 0, 0.1)
	jingle_stream_player.volume_linear = DEFAULT_VOL
	jingle_stream_player.stream = load(FILEPATH + jingle_name + ".ogg")
	jingle_stream_player.play()
	await jingle_stream_player.finished
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(music_stream_player, "volume_linear", DEFAULT_VOL, 1)

func is_song_playing(song_name: String) -> bool:
	if music_stream_player.stream.resource_path == (FILEPATH + song_name + ".ogg") and music_stream_player.playing:
		return true
	return false
