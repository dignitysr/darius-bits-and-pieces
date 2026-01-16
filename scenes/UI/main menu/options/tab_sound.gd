extends TabContainer


@onready var hover_sound: AudioStreamPlayer = get_parent().get_node("%HoverSound")
@onready var press_sound: AudioStreamPlayer = get_parent().get_node("%PressSound")


func _ready() -> void:
	connect("tab_hovered", hover_sound.play.unbind(1))
	connect("tab_clicked", press_sound.play.unbind(1))
