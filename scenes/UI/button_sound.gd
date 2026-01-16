class_name ButtonSound
extends Button


@export var hover_name: String = "%HoverSound"
@export var press_name: String = "%PressSound"

@onready var hover_sound: AudioStreamPlayer = get_parent().get_node_or_null(hover_name)
@onready var press_sound: AudioStreamPlayer = get_parent().get_node_or_null(press_name)


func _ready() -> void:
	if is_instance_valid(hover_sound):
		connect("mouse_entered", hover_sound.play)
	if is_instance_valid(press_sound):
		connect("button_down", press_sound.play)
