class_name MenuController
extends Control

const TRANS_TIME: float = 0.4

@onready var active = %Active
@onready var inactive = %Inactive

func _ready():
	MusicManager.play_song("dariusmenu")

func trans(from: String, to: String):
	var from_node: BaseMenu = get_node("%"+from)
	var to_node: BaseMenu = get_node("%"+to)
	to_node.reparent(active)
	from_node.reparent(inactive)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	from_node.modulate.a = 1
	to_node.modulate.a = 1
	to_node.get_node("%DitherMask").dither_percent = 0
	tween.tween_property(from_node.get_node("%DitherMask"), "dither_percent", 0, TRANS_TIME)
	tween.tween_property(to_node.get_node("%DitherMask"), "dither_percent", 1, TRANS_TIME)
