extends Control

@export var achievement_button_scene: PackedScene
@export var unlocked_color: Color
@export var locked_color: Color

@onready var achievement_container = %AchievementContainer
@onready var achievement_desc = %AchievementDesc
@onready var unlocked_check = %UnlockedCheck

var achievements: Dictionary

func _ready():
	reload_achievements()

func achievement_pressed(achievement: String) -> void:
	achievement_desc.text = achievements[achievement].description
	unlocked_check.button_pressed = achievements[achievement].unlocked
	
func reload_achievements() -> void:
	achievements = AchievementManager.achievements
	for achievement_name: String in achievements:
		var achievement_button: Button = achievement_button_scene.instantiate()
		achievement_button.text = achievement_name
		if achievements[achievement_name].unlocked:
			set_button_bg_modulate(achievement_button, unlocked_color)
		else:
			set_button_bg_modulate(achievement_button, locked_color)
		achievement_container.add_child(achievement_button)
		achievement_button.connect("button_down", achievement_pressed.bind(achievement_name))
	achievement_desc.text = achievements[achievements.keys()[0]].description
	unlocked_check.button_pressed = achievements[achievements.keys()[0]].unlocked

func set_button_bg_modulate(box: Button, color: Color):
	var normal_stylebox: StyleBoxTexture = box.get_theme_stylebox("normal").duplicate()
	var hover_stylebox: StyleBoxTexture = box.get_theme_stylebox("hover").duplicate()
	var pressed_stylebox: StyleBoxTexture = box.get_theme_stylebox("pressed").duplicate()
	normal_stylebox.modulate_color = Color(color, 0.8)
	hover_stylebox.modulate_color = Color(color, 0.6)
	pressed_stylebox.modulate_color = Color(color, 1)
	box.add_theme_stylebox_override("normal", normal_stylebox)
	box.add_theme_stylebox_override("hover", hover_stylebox)
	box.add_theme_stylebox_override("pressed", pressed_stylebox)
