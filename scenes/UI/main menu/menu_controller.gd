class_name MenuController
extends Control

@onready var trans_player = %TransPlayer
@onready var active = %Active
@onready var inactive = %Inactive

func trans(from: String, to: String):
	var from_node: BaseMenu = get_node("%"+from)
	var to_node: BaseMenu = get_node("%"+to)
	to_node.reparent(active)
	from_node.reparent(inactive)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(from_node, "modulate:a", 0, 0.5)
	tween.tween_property(to_node, "modulate:a", 1, 0.5)
