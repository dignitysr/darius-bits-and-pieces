class_name LevelSelect
extends BaseMenu

@onready var return_button = %Return

@onready var level_container = %LevelContainer

@export var levels_resource: LevelsResource
@export var level_select_button_script: PackedScene

func _ready() -> void:
	return_button.connect("button_down", on_return_pressed)
	for level: LevelResource in levels_resource.levels:
		var level_select_button: Button = level_select_button_script.instantiate()
		level_select_button.text = level.name
		level_select_button.icon = level.icon
		level_select_button.connect("button_down", on_select.bind(level.scene))
		level_container.add_child(level_select_button)

func on_select(level: String) -> void:
	TransitionManager.trans_to(level)

func on_return_pressed() -> void:
	trans_to("MainMenu")
