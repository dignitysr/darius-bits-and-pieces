extends BaseMenu

@onready var play = %Play
@onready var options = %Options
@onready var quit = %Quit

func _ready():
	play.connect("button_down", play_pressed)
	options.connect("button_down", options_pressed)
	
func play_pressed() -> void:
	trans_to("Options")
	
func options_pressed() -> void:
	trans_to("Options")
