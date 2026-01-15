extends CanvasLayer

@onready var trans_player: AnimationPlayer = %TransPlayer

func trans_to(scene: String) -> void:
	trans_player.play_backwards("dither")
	await trans_player.animation_finished
	get_tree().change_scene_to_file(scene)
	trans_player.play("dither")
