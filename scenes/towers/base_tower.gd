class_name BaseTower
extends CharacterBody2D

enum Rank {F, D, C, B, A, S}

@onready var animator: AnimatedSprite2D = $Animator
@onready var enemy_detection: Area2D = $EnemyDetection
@onready var pickup_detection: Area2D = $PickupDetection

@export_category("Tower Information")
@export var tower_name: String = "Darius Goat"
@export var path_name: String = ""

@export_category("Tower Details")
@export var durability_mult: float = 1.5
@export var init_durability: float = 100
@export var parts_dropped: Dictionary[String, int]

@export_category("References")
@export var inventory_manager: InventoryManager

var durability: float = 0
var rank: Rank
var broken: bool = false
var dithering_intensity: float = 0

var selected_enemy: BaseEnemy

func _ready():
	durability = init_durability * (durability_mult * (rank + 1))

func _attack() -> void:
	durability -= 1

func _physics_process(delta) -> void:
	var min_dist = INF
	for enemy: BaseEnemy in enemy_detection.get_overlapping_bodies():
		var dist = position.distance_squared_to(enemy.position)
		if dist < min_dist:
			min_dist = dist
			selected_enemy = enemy
			
	if broken && !pickup_detection.get_overlapping_bodies().is_empty():
		dithering_intensity = 0.05
		for part in parts_dropped:
			if !inventory_manager.parts.has(part):
				inventory_manager.parts[part] = {}

			inventory_manager.parts[part][rank] = parts_dropped[part]
	
	if dithering_intensity > 0:
		animator.get_material().set_shader_parameter("intensity", dithering_intensity)
		dithering_intensity += delta

	
func _break() -> void:
	broken = true
