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

@export_category("Wave Information")
@export var time_between_waves: float = 60 ## In seconds
@export var time_between_enemies: float = 0.5 ## In seconds

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

var run_wave: bool = false
var wave_number: int = -1
var timer: float

var subscribers: int = 1

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
	
var active_buff := Buffs.SLOW

var darius_name: String = "Darius the Mailman"


func _ready() -> void:
	update_stats()
	darius_name_label.text = darius_name
	ability_label.text = "Featuring: " + buffs[active_buff]
	timer = time_between_waves
	MusicManager.play_song("darius_wave_intermission")

func _physics_process(delta) -> void:
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
				run_wave = true
			
	if Input.is_action_just_pressed("back"):
		var options = options_screen.instantiate()
		options.owner = self
		UI.add_child(options)
		get_tree().paused = true

func add_parts(parts_dropped: Dictionary[String, int], rank: InventoryManager.Rank):
	var total_parts: int = 0
	if active_buff == Buffs.PARTS:
		for part: String in parts_dropped:
			@warning_ignore("narrowing_conversion")
			parts_dropped[part] = roundi(parts_dropped[part] + parts_dropped[part]*0.25)
	var quantity_container_scene = quantity_container.instantiate()
	quantity_container_scene.parts = parts_dropped
	quantity_container_scene.rank = good_util.direct_image(small_ranks_resource.ranks[rank])
	quantities_container.add_child(quantity_container_scene)
	for part: String in parts_dropped:
		total_parts += parts_dropped[part]
		if !inventory_manager.parts.has(part):
			inventory_manager.parts[part] = {}
		if !inventory_manager.parts[part].has(rank):
			inventory_manager.parts[part][rank] = 0

		inventory_manager.parts[part][rank] += parts_dropped[part]
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
