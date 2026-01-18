extends CanvasLayer

@onready var achievement_name_label = %AchievementName
@onready var trans_player = %TransPlayer

var resource_dir = "res://tools/achievements/resources/"
var achievements: Dictionary
var achievement_keys: Array

var total_achievements: int
var unlocked_achievements: int

signal unlocked_achievement

class Achievement:
	var achievement_name: String
	var description: String
	var unlocked: bool = false
	
	func _init(n: String, d: String):
		achievement_name = n
		description = d
		
signal done_loading

func _ready() -> void:
	for resource: String in DirAccess.get_files_at(resource_dir):
		var achievement: AchievementData = load(resource_dir + resource.trim_suffix(".remap"))
		achievement_keys.append(achievement)
	achievement_keys.sort_custom(sort_ascending)
	for achievement: AchievementData in achievement_keys:
		store_achievements(achievement.achievement_name, achievement.description)
	done_loading.emit()
	
func sort_ascending(a: AchievementData, b: AchievementData):
	if a.achievement_index < b.achievement_index:
		return true
	return false


func store_achievements(achievement_name: String, description: String) -> void:
	var achievement = Achievement.new(achievement_name, description)
	achievements[achievement_name] = achievement
	total_achievements += 1
	achievement.unlocked = Save.load_setting("achievements", achievement_name, false)
	if achievement.unlocked:
		unlocked_achievements += 1

func unlock(achievement_name: String) -> void:
	if achievements[achievement_name].unlocked:
		return
	MusicManager.play_jingle("darius_achievement")
	trans_player.play("RESET")
	achievements[achievement_name].unlocked = true
	unlocked_achievements += 1
	achievement_name_label.text = achievement_name
	trans_player.play("slide")
	Save.change_setting("achievements", achievement_name, true)
	StatsManager.save_stats()
	unlocked_achievement.emit()
