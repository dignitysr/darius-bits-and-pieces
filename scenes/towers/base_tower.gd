class_name BaseTower
extends CharacterBody2D

enum Rank {F, D, C, B, A, S}

@onready var animator: AnimatedSprite2D = $Animator
@onready var enemy_detection: Area2D = $EnemyDetection
@onready var pickup_detection: Area2D = $PickupDetection
@onready var spawner: Node2D = %Spawner

@export_category("Tower Information")
@export var tower_name: String = "Darius Goat"
@export var path_name: String = ""
@export var variant_num: int = 0

@export_category("Tower Details")
@export var durability_mult: float = 1.5
@export var init_durability: float = 100
@export var damage: float = 20
@export var parts_dropped: Dictionary[String, int]
@export var attack_speed: int = 2000

@export_category("References")
@export var inventory_manager: InventoryManager
@export var mail: PackedScene

var durability: float = 0
var rank: Rank
var broken: bool = false
var dithering_intensity: float = 0

var cooldown: int = attack_speed
var random_frame

var selected_enemy: BaseEnemy


func _ready():
	random_frame = str(randi_range(1, variant_num))
	print(random_frame)
	animator.animation = random_frame
	durability = init_durability * (durability_mult * (rank + 1))

func _attack() -> void:
	durability -= 1

func _physics_process(delta) -> void:
	#print(enemy_detection.get_overlapping_areas())
	var min_dist = INF
	for enemy_area: Area2D in enemy_detection.get_overlapping_areas():
		var dist = position.distance_squared_to(enemy_area.get_parent().position)
		if dist < min_dist:
			min_dist = dist
			selected_enemy = enemy_area.get_parent()
			animator.animation = str(random_frame) + "shoot"
	if enemy_detection.get_overlapping_areas().is_empty():
		selected_enemy = null
		animator.animation = str(random_frame)
			
	if broken && !pickup_detection.get_overlapping_bodies().is_empty():
		dithering_intensity = 0.05
		for part in parts_dropped:
			if !inventory_manager.parts.has(part):
				inventory_manager.parts[part] = {}

			inventory_manager.parts[part][rank] = parts_dropped[part]
	
	if dithering_intensity > 0:
		animator.get_material().set_shader_parameter("intensity", dithering_intensity)
		dithering_intensity += delta
		
	while cooldown > 0:
		cooldown -= 1
		await get_tree().physics_frame
	if cooldown <= 0:
		if is_instance_valid(selected_enemy):
			_attack()
		cooldown = attack_speed

	
func _break() -> void:
	broken = true
