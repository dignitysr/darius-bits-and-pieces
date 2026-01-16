extends Node

const SAVE_TIME = 30

var stats: Dictionary = {
	"playtime": 0,
	"playtime_string": 0,
	"towers_placed_total": 0,
	"recruited_customers_total": 0,
	"subscribers_total": 0,
	"defeated_rickmechs_total": 0,
	"towers_placed": 0,
	"recruited_customers": 0,
	"subscribers": 0,
	"defeated_rickmechs": 0,
	"current_level": "",
}

var save_timer = SAVE_TIME

var init_unix_time: float
var init_time: float

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_stats()
	init_time = stats["playtime"]
	init_unix_time = Time.get_unix_time_from_system()

func _process(delta) -> void:
	stats["playtime"] = (Time.get_unix_time_from_system() - init_unix_time) + init_time
	stats["playtime_string"] = "%dh %dm %ds" % [floori(stats["playtime"]/3600.0), floori(int(stats["playtime"])%3600)/60.0, roundi(int(stats["playtime"])%60)]
	
	if save_timer > 0:
		save_timer -= delta
	else:
		save_stats()
		save_timer = SAVE_TIME
	
func load_stats() -> void:
	for stat: String in stats:
		stats[stat] = Save.load_setting("stats", stat, 0)

func save_stats() -> void:
	for stat: String in stats:
		Save.change_setting("stats", stat, stats[stat])
