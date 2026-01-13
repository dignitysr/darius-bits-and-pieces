extends BaseMenu

@onready var return_button = %Return

func _ready():
	return_button.connect("button_down", return_button_pressed)
	
func return_button_pressed() -> void:
	trans_to("MainMenu")
