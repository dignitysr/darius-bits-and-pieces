class_name OptionSound
extends OptionButton


@onready var hover_sound: AudioStreamPlayer = get_parent().get_node("%HoverSound")
@onready var press_sound: AudioStreamPlayer = get_parent().get_node("%PressSound")


func _ready() -> void:
	connect("mouse_entered", hover_sound.play)
	connect("item_selected", press_sound.play.unbind(1))
