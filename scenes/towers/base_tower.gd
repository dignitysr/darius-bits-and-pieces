class_name BaseTower
extends CharacterBody2D

@onready var animator: AnimatedSprite2D = $Animator
@onready var enemy_detection: Area2D = $EnemyDetection
@onready var pickup_detection: Area2D = $PickupDetection
@onready var spawner: Node2D = %Spawner
@onready var debris_sprite = %DebrisSprite
@onready var broken_bar = %BrokenBar

@export_category("Tower Information")
@export var tower_name: String = "Darius Goat"
@export var path_name: String = ""
@export var variant_num: int = 0

@export_category("Tower Details")
@export var durability_mult: float = 1.5
@export var init_durability: float = 100
@export var damage: float = 10
@export var damage_mult: float = 2
@export var parts_dropped: Dictionary[String, int]
@export var attack_speed: int = 30
@export var tower_repair_buff: float = 0.005

@export_category("References")
@export var inventory_manager: InventoryManager
@export var mail: PackedScene

var durability: float = 0
var rank: InventoryManager.Rank
var broken: bool = false
var dithering_intensity: float = 0
var max_durability: float = (init_durability * (durability_mult * (rank + 1)))

var cooldown: int = attack_speed
var random_frame

var selected_enemy: BaseEnemy


func _ready():
	debris_sprite.hide()
	random_frame = str(randi_range(1, variant_num))
	animator.animation = random_frame
	durability = max_durability
	damage = damage * (damage_mult * (rank + 1))
	broken_bar.position.y -= animator.sprite_frames.get_frame_texture(animator.animation, 0).get_size().y + 10
	print(global_position)
	broken_bar.max_value = durability

func _attack() -> void:
	durability -= 1
	if durability <= 0:
		_break()
		animator.hide()
		debris_sprite.show()

func _physics_process(delta) -> void:
	var min_dist = INF
	if !broken:
		for enemy_area: Area2D in enemy_detection.get_overlapping_areas():
			if enemy_area.get_parent() is BaseEnemy:
				var dist = position.distance_squared_to(enemy_area.get_parent().position)
				if dist < min_dist:
					min_dist = dist
					selected_enemy = enemy_area.get_parent()
					animator.animation = str(random_frame) + "shoot"
		if !"EnemyArea" in str(enemy_detection.get_overlapping_areas()):
			selected_enemy = null
			animator.animation = str(random_frame)
		if cooldown > 0:
			cooldown -= 1
		if cooldown <= 0:
			if is_instance_valid(selected_enemy):
				_attack()
			if !pickup_detection.get_overlapping_bodies().is_empty() && inventory_manager.level.active_buff == "repair":
				if durability != max_durability:
					var tween := get_tree().create_tween()
					animator.modulate = Color.ROYAL_BLUE
					tween.tween_property(animator, "modulate", Color.WHITE, 0.2)
				durability = clamp(durability + max_durability*tower_repair_buff, 0, max_durability)
			print(durability)
			cooldown = attack_speed
			
	broken_bar.value = durability
	if broken && !pickup_detection.get_overlapping_bodies().is_empty():
		dithering_intensity = 0.05
		pickup_detection.monitoring = false
		inventory_manager.add_parts(parts_dropped, rank)
		
		
	
	if dithering_intensity > 0:
		debris_sprite.get_material().set_shader_parameter("intensity", dithering_intensity)
		dithering_intensity += delta
	if dithering_intensity > 1:
		queue_free()

	
func _break() -> void:
	broken = true
	enemy_detection.monitoring = false
