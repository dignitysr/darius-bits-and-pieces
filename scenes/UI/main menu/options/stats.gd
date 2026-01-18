extends Control

@onready var text = %Text
@onready var end_run = %EndRun
@onready var reset_save = %ResetSave

func _ready() -> void:
	print(owner)
	if !get_tree().current_scene is MenuController:
		end_run.show()
	else:
		end_run.hide()
	end_run.connect("button_down", on_end_run_pressed)
	reset_save.connect("button_down", on_reset_pressed)

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

func on_end_run_pressed():
	if end_run.text == "Are you sure?":
		TransitionManager.trans_to("res://scenes/UI/main menu/menu_controller.tscn")
		owner.dither(1, 0)
		get_tree().paused = false
	if end_run.text == "End Run":
		end_run.text = "Are you sure?"
		
func on_reset_pressed():
	if reset_save.text == "Are you REALLY sure?":
		var dir = DirAccess.open("user://")
		if dir.file_exists("settings.cfg"):
			dir.remove("settings.cfg")
		StatsManager.reset_stats()
	if reset_save.text == "Are you sure?":
		reset_save.text = "Are you REALLY sure?"
	if reset_save.text == "Reset Save":
		reset_save.text = "Are you sure?"
