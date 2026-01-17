extends Control

@onready var return_button = %ReturnButton
@onready var retry_button = %RetryButton
@onready var button_container = %ButtonContainer

func _ready():
	get_tree().paused = false
	MusicManager.play_song("darius_gameover")
	return_button.connect("button_down", on_return_pressed)
	retry_button.connect("button_down", on_retry_pressed)
	button_container.hide()
	await get_tree().create_timer(5).timeout
	button_container.show()
	var dither = 1
	while dither > 0:
		button_container.material.set_shader_parameter("intensity", dither)
		dither -= 0.05
		await get_tree().process_frame

func on_return_pressed():
	TransitionManager.trans_to("res://scenes/UI/main menu/menu_controller.tscn")
	
func on_retry_pressed():
	TransitionManager.trans_to(StatsManager.stats["current_level"])
