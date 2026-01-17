extends BaseMenu

@onready var play = %Play
@onready var options = %Options
@onready var quit = %Quit

func _ready():
	play.connect("button_down", play_pressed)
	options.connect("button_down", options_pressed)
	quit.connect("button_down", quit_pressed)
	
func play_pressed() -> void:
	trans_to("LevelSelect")
	
func options_pressed() -> void:
	trans_to("Options")
	
func quit_pressed() -> void:
	StatsManager.save_stats()
	get_tree().quit()
