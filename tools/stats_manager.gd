extends Node

const SAVE_TIME = 20

var stats: Dictionary

var default_stats: Dictionary = {
	"playtime": 0,
	"playtime_string": "",
	"towers_placed_total": 0,
	"recruited_customers_total": 0,
	"subscribers_total": 0,
	"defeated_rickmechs_total": 0,
	"towers_placed_unsaved": 0,
	"recruited_customers_unsaved": 0,
	"subscribers_unsaved": 0,
	"defeated_rickmechs_unsaved": 0,
	"current_level": "",
	"wave_60_maps": [],
	"witnessed_buffs": [],
}

var save_timer = SAVE_TIME

var init_unix_time: float
var init_time: float

func _ready() -> void:
	set_process(false)
	await load_stats()
	init_time = stats["playtime"]
	init_unix_time = Time.get_unix_time_from_system()
	set_process(true)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta) -> void:
	stats["playtime"] = (Time.get_unix_time_from_system() - init_unix_time) + init_time
	stats["playtime_string"] = "%dh %dm %ds" % [floori(stats["playtime"]/3600.0), floori(int(stats["playtime"])%3600)/60.0, roundi(int(stats["playtime"])%60)]
	
	if save_timer > 0:
		save_timer -= delta
	else:
		save_stats()
		save_timer = SAVE_TIME
	
func load_stats() -> void:
	for stat: String in default_stats:
		if Save.has_setting("stats", stat):
			stats[stat] = Save.load_setting("stats", stat, 0)
		else:
			stats[stat] = default_stats[stat]
			Save.change_setting("stats", stat, stats[stat])

func save_stats() -> void:
	for stat: String in stats:
		if !"unsaved" in stat:
			Save.change_setting("stats", stat, stats[stat])

func reset_stats() -> void:
	for stat: String in stats:
		stats[stat] = default_stats[stat]
	AchievementManager.reset_achievements()
	init_time = 0
	init_unix_time = Time.get_unix_time_from_system()
	save_stats()
