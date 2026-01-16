extends Node

const FILEPATH = "res://assets/music/"
const FADEOUT_VOL = -40

@onready var music_stream_player = %MusicStreamPlayer
@onready var jingle_stream_player = %JingleStreamPlayer

func play_song(song_name: String):
	music_stream_player.stop()
	music_stream_player.stream = load(FILEPATH + song_name + ".ogg")
	music_stream_player.play()
	
func _process(_delta):
	print(music_stream_player.volume_db)
	
func play_jingle(jingle_name: String):
	jingle_stream_player.stop()
	var tween := get_tree().create_tween()
	tween.tween_property(music_stream_player, "volume_db", FADEOUT_VOL, 0.1)
	jingle_stream_player.stream = load(FILEPATH + jingle_name + ".ogg")
	jingle_stream_player.play()
	await jingle_stream_player.finished
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(music_stream_player, "volume_db", 0, 1)
