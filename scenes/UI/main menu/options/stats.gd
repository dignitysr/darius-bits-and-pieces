extends Control

@onready var text = %Text
@onready var end_run = %EndRun
@onready var reset_save = %ResetSave

func _ready() -> void:
	if !owner is MenuController:
		end_run.show()
	else:
		end_run.hide()

func _physics_process(_delta):
	var template = """Total
	Playtime: {playtime_string}
	Achievements: {ach_unlocked}/{ach_total} ({ach_percent}%)
	Placed Towers: {towers_placed_total}
	Recruited Customers: {recruited_customers_total}
	Subscribers: {subscribers_total}
	Defeated Rickmechs: {defeated_rickmechs_total}

	Highest Per Run
	Placed Towers: {towers_placed_unsaved}
	Recruited Customers: {recruited_customers_unsaved}
	Subscribers: {subscribers_unsaved}
	Defeated Rickmechs: {defeated_rickmechs_unsaved}"""
	
	@warning_ignore("integer_division")
	text.text = template.format(StatsManager.stats.merged({"ach_unlocked": AchievementManager.unlocked_achievements, "ach_total": AchievementManager.total_achievements, "ach_percent": (100*AchievementManager.unlocked_achievements)/(AchievementManager.total_achievements)}))
