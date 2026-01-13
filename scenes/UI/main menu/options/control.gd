extends HBoxContainer

const CHANGE_TIMER = 5 #In frames

@onready var label: Label = get_node("Label")
@onready var button: Button = get_node("Action")

var timer_active: bool = false
var timer: float = 0
var action_name: String

func _ready() -> void:
	action_name = name.to_lower()
	action_name = action_name.replace(" ", "_")
	button.text = Save.load_setting("controls", action_name, InputMap.action_get_events(action_name)[0]).as_text()
	button.text = button.text.replace(" (Physical)", "")
	button.pressed.connect(button_pressed)
	Save.change_setting("controls", action_name, InputMap.action_get_events(action_name)[0])
	
func _input(event: InputEvent) -> void:
	if timer_active && !event is InputEventMouseMotion:
		button.text = event.as_text()
		Save.change_setting("controls", action_name, event)
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		button.text = button.text.replace(" (Physical)", "")
		timer_active = false
	
func _process(delta: float) -> void:
	if timer_active:
		if timer > 0:
			timer -= delta
		else:
			timer_active = false
			button.text = InputMap.action_get_events(action_name)[0].as_text()
		
func button_pressed() -> void:
	timer = CHANGE_TIMER
	button.text = "Waiting..."
	timer_active = true
