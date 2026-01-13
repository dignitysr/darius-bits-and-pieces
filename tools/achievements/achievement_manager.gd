extends Control

@onready var achievement_name_label = %AchievementName
@onready var trans_player = %TransPlayer

var resource_dir = "res://tools/achievements/resources/"
var achievements: Dictionary

class Achievement:
	var achievement_name: String
	var description: String
	var unlocked: bool = false
	
	func _init(n: String, d: String):
		achievement_name = n
		description = d

func _ready() -> void:
	var dir := DirAccess.open(resource_dir)
	for resource: String in dir.get_files():
		var achievement: AchievementData = load(resource_dir + resource)
		store_achievements(achievement.achievement_name, achievement.description)
	

func store_achievements(achievement_name: String, description: String) -> void:
	var achievement = Achievement.new(achievement_name, description)
	achievements[achievement_name] = achievement
	achievement.unlocked = Save.load_setting("achievements", achievement_name, false)

func unlock(achievement_name: String) -> void:
	achievements[achievement_name].unlocked = true
	achievement_name_label.text = achievement_name
	trans_player.play("slide")
	Save.change_setting("achievements", achievement_name, true)
