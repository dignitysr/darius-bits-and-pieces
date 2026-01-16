class_name SliderSound
extends HSlider


@onready var hover_sound: AudioStreamPlayer = get_parent().get_node("%HoverSound")


func _ready() -> void:
	connect("mouse_entered", hover_sound.play)
