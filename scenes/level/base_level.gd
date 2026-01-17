class_name BaseLevel
extends Node2D

enum Buffs {SLOW, REPAIR, PARTS, FASTER}

@export_category("Exports")
@export var wave_resource: LevelResource
@export var enemies_resource: EnemiesResource
@export var small_ranks_resource: RanksResource
@export var objects_list: ObjectList
@export var quantity_container: PackedScene
@export var player_scene: PackedScene
@export var options_screen: PackedScene
@export var rickmech: PackedScene

@export_category("Wave Information")
@export var time_between_waves: float = 60 ## In seconds
@export var time_between_enemies: float = 0.5 ## In seconds
@export var rickmech_spawn_time = 300
@export var news_random_time: int = 360

@onready var enemy_spawner = %EnemySpawner
@onready var enemy_container = %Enemies
@onready var inventory_manager = %InvManager
@onready var quantities_container = %QuantitiesContainer
@onready var player = $Player
@onready var player_spawner = $PlayerSpawner
@onready var darius_name_label = %DariusName
@onready var ability_label = %Ability
@onready var sub_count = %SubCount
@onready var breaking_news = %BreakingNews
@onready var UI = %UI
@onready var lose_axis = %LoseAxis
@onready var net_worth = %NetWorth
@onready var net_worth_label = %NetWorthLabel
@onready var tileset = %Tileset

var run_wave: bool = false
var wave_number: int = -1
var timer: float
var subscribers: int = 1
var x_range: int = 0
var rickmech_spawn_timer: float = 0
var news_timer: float = 0
var run_time: float = 0

var buffs: Array = [
	"Slow Down Customers",
	"Repair Tools",
	"25% More Parts",
	"Move Slightly Faster"]

var buff_prefixes: Array = [
	'Buff: ',
	'Ability: ',
	'Featuring: ',
	'Trade: '
]

var milestones: Dictionary = {
	1e3: ["New OOPS competitor? All you need to know about DPS.", false],
	1e4: ["OOPS competitor gaining steam in recent push to reach ten thousand subscribers.", false],
	1e5: ["DPS becoming the second-most-used postal service behind Rick Aschez's OOPS. Is it on track to dethrone it?", false],
	1e6: ["DPS subscribership surpassing the population of a small country. OOPS in grave danger.", false]
}

var news_snippets: Array = [
	"'BEING OBSESSIVE IS NEVER A GOOD THING' SAYS PROGRAMMER.",
	"'DPS doesn't stand for damage per second?' asks OOPS representative.",
	"'Why choose OOPS over DPS?' CEO Rick Aschez says: 'You wouldn't get this from any other guy.'",
	"Hold on, what did you say this game was about again?' asks confused composer.",
	"When asked about the lack of janitorial workers at DPS, COO Dmitri refused to comment.",
	"'C'mon, it's Aschez, not Sanchez!': OOPS CEO Blasts Misinformation",
	"DPS Seeks Millions in Damages from 'Rovert' for Unlicensed Fan Character 'Mario'",
	"AD: Get 30% off all Nuggie-Wuggies at McDesu's! For kids, meet the real McDonald-Chan in the newly built Isekai Place!",
	"Local citizen's cat found dead from heart attack. Autopsy reveals heavy lasagna consumption.",
	"It Could Happen to You - Invest in Tile Clipping Insurance Today!",
	"'Hello, I'm Dwayne the John Rockson', says local rock. Researchers currently conducting further investigation.",
	"Ready to 'Give Up' Biased News Sources? Subscribe to the Darius News Network, the World's Only Unbiased News Source. This slot was brought to you by the DPS.",
	"PSA From DPS: 'Being called 'Super' on the Job Doesn't Protect From Strain. Lift With Your Legs.'",
	"LIFESTYLE: How You Can Save the Environment in 5 Minutes a Day by Being Gentle With Mailboxes",
	"'Tragedy Strikes Local Orphanage — Hundreds Lost in Devastating Inferno.' ​I hope this headline meets your requirements! Is there anything else I can assist you with today?",
	"The Sad Truth: 90% of Mail Based Casualties Come From Customer Dissatisfaction. Other leading causes include: 6% Transportation Accidents, 3% Unattended Enemies, Hazards and Dogs, and 1% Giant Pits.",
]
	
var active_buff := Buffs.SLOW

var darius_name: String = "Darius the Mailman"


func _ready() -> void:
	update_stats()
	#news_timer = randf_range(news_random_time/2.0, news_random_time)
	darius_name_label.text = darius_name
	ability_label.text = "Featuring: " + buffs[active_buff]
	timer = time_between_waves
	MusicManager.play_song("darius_wave_intermission")
	StatsManager.stats["current_level"] = wave_resource.scene
	var tiles_array_sorted: Array = tileset.get_used_cells()
	tiles_array_sorted.sort_custom(sort_by_ascending_x)
	x_range = tiles_array_sorted[0].x*16
		
func sort_by_ascending_x(a: Vector2, b: Vector2):
	if a.x > b.x:
		return true
	return false

func _physics_process(delta) -> void:
	run_time += delta
	if run_wave && enemy_container.get_children().is_empty():
		for enemy: String in wave_resource.waves[wave_number]:
			for number: int in wave_resource.waves[wave_number][enemy]["number"]:
				var enemy_instance: BaseEnemy = enemies_resource.enemies[enemy].instantiate()
				enemy_instance.position = enemy_spawner.position
				enemy_instance.rank = wave_resource.waves[wave_number][enemy]["rank"]
				enemy_instance.inventory_manager = inventory_manager
				enemy_container.add_child(enemy_instance)
				await get_tree().create_timer(time_between_enemies, false).timeout
		run_wave = false
	else:
		if enemy_container.get_children().is_empty():
			if timer > 0:
				timer -= delta
			else:
				timer = time_between_waves
				wave_number += 1
				if wave_number == 21:
					AchievementManager.unlock("A Tough Battle")
				if wave_number == 61:
					AchievementManager.unlock("A War Victorious")
					if !StatsManager.stats["wave_60_maps"].has(wave_resource.name):
						StatsManager.stats["wave_60_maps"].append(wave_resource.name)
					if StatsManager.stats["wave_60_maps"].size() == 4:
						AchievementManager.unlock("Man of Mail")
				MusicManager.play_jingle("darius_wave_start")
				run_wave = true
			
	if Input.is_action_just_pressed("pause"):
		var options = options_screen.instantiate()
		options.owner = self
		UI.add_child(options)
		get_tree().paused = true
		
	if rickmech_spawn_timer <= 0:
		var rickmech_scene: Rickmech = rickmech.instantiate()
		rickmech_scene.level = self
		rickmech_scene.player = player
		rickmech_scene.run_time = run_time
		rickmech_spawn_timer = rickmech_spawn_time
		add_child(rickmech_scene)
	else:
		rickmech_spawn_timer -= delta
		
	if news_timer <= 0:
		breaking_news.show_news(news_snippets[randi_range(0, news_snippets.size()-1)])
		news_timer = randf_range(news_random_time/2.0, news_random_time)
	else:
		randomize()
		news_timer -= delta

func add_parts(parts_dropped: Dictionary[String, int], rank: InventoryManager.Rank, add_subs: bool = true):
	var total_parts: int = 0
	for part: String in parts_dropped:
		@warning_ignore("narrowing_conversion")
		total_parts += parts_dropped[part]
		if active_buff == Buffs.PARTS:
			parts_dropped[part] = roundi(parts_dropped[part] + parts_dropped[part]*0.25)
	var quantity_container_scene = quantity_container.instantiate()
	quantity_container_scene.parts = parts_dropped
	quantity_container_scene.rank = good_util.direct_image(small_ranks_resource.ranks[rank])
	quantities_container.add_child(quantity_container_scene)
	for part: String in parts_dropped:
		if !inventory_manager.parts.has(part):
			inventory_manager.parts[part] = {}
		if !inventory_manager.parts[part].has(rank):
			inventory_manager.parts[part][rank] = 0

		inventory_manager.parts[part][rank] += parts_dropped[part]
	if add_subs:
		subscribers += roundi(pow((total_parts)*(rank+1)*2, 2))
	update_stats()
		
func update_stats() -> void:
	sub_count.text = math_util.convert_num(subscribers)
	for sub_milestone: float in milestones:
		if subscribers >= sub_milestone && milestones[sub_milestone][1] == false:
			breaking_news.show_news(milestones[sub_milestone][0])
			milestones[sub_milestone][1] = true
	if net_worth.max_value < subscribers*10:
		var tween := get_tree().create_tween()
		tween.tween_property(net_worth, "max_value", subscribers*10, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	net_worth_label.add_theme_color_override("font_color", Color(1, (1-net_worth.value/net_worth.max_value), (1-net_worth.value/net_worth.max_value), 1))

func on_darius_death() -> void:
	var intensity = 0
	player.set_physics_process(false)
	while intensity < 1:
		intensity += 0.01
		player.animator.get_material().set_shader_parameter("intensity", intensity)
		await get_tree().physics_frame
	var new_player: Character = player_scene.instantiate()
	new_player.position = player_spawner.position
	new_player.inventory_manager = inventory_manager
	randomize()
	@warning_ignore("int_as_enum_without_cast")
	active_buff = randi_range(0, int(Buffs.FASTER))
	darius_name = "%sarius the %sailman" % [char(randi_range(65, 90)), char(randi_range(65, 90))]
	darius_name_label.text = darius_name
	ability_label.text = buff_prefixes[randi_range(0, buff_prefixes.size()-1)] + buffs[active_buff]
	add_child(new_player)
	player.animator.get_material().set_shader_parameter("intensity", 0)
	new_player.camera.make_current()
	player.queue_free()
	player = new_player
