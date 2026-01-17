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
			achievement_button.theme_type_variation = "AchievementButtonUnlocked"
		achievement_container.add_child(achievement_button)
		achievement_button.connect("button_down", achievement_pressed.bind(achievement_name))
	achievement_desc.text = achievements[achievements.keys()[0]].description
	unlocked_check.button_pressed = achievements[achievements.keys()[0]].unlocked
