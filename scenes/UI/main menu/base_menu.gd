class_name BaseMenu
extends Control

@export var menu_controller: MenuController

func trans_to(scene: String) -> void:
	menu_controller.trans(self.name, scene)
