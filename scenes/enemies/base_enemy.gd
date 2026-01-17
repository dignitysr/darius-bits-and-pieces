class_name BaseEnemy
extends CharacterBody2D

const GRAVITY = 10
const JUMP_POW = 9
const SAFETY_MARGIN = 20

@onready var pathplayer = $PathPlayer
@onready var enemy_area = %EnemyArea
@onready var animator = %Animator
@onready var wall_finder = %WallFinder
@onready var cheer: AudioStreamPlayer2D = %Cheer
@onready var hit: AudioStreamPlayer2D = %Hit

var dead: bool = false
var dithering_intensity: float = 0
var inventory_manager: InventoryManager

@export_category("Enemy Info")
@export var enemy_name: String
@export var enemy_path: String = ""
@export var airborne: bool = false
@export var palettes: Array[Texture2D]

@export_category("Enemy Stats")
@export var health: float = 20
@export var health_mult: float = 1.5
@export var rank: InventoryManager.Rank
@export var death_speed: int = 4
@export var speed: float = 50
@export var parts_dropped: Dictionary[String, int]

@export_category("Flier Enemy Info")
@export var flier_spawn_pos: float
@export var freq: int = 8
@export var amp: int = 6

var init_speed: float
var last_in_line: bool = false

func _ready() -> void:
	randomize()
	amp = randi_range(amp/2, amp)
	freq = randi_range(freq/2, freq)
	if !palettes.is_empty():
		animator.material.set_shader_parameter("palette_out", palettes[randi_range(0, palettes.size()-1)])
	health = health * (health_mult * (rank + 1))
	init_speed = speed
	enemy_area.connect("body_entered", on_mail_entered)
	
func _physics_process(delta):
	velocity.x = speed
	if !airborne:
		if !is_on_floor():
			velocity.y += GRAVITY
			animator.animation = "jump"
		else:
			animator.animation = "walk"
	else:
		position.y = amp*sin(position.x/freq) + flier_spawn_pos
	if dead:
		animator.get_material().set_shader_parameter("intensity", dithering_intensity)
		dithering_intensity += delta*death_speed
		enemy_area.monitorable = false
		enemy_area.monitoring = false
	if dithering_intensity >= 1:
		set_physics_process(false)
		reparent(inventory_manager.level)
		inventory_manager.level.enemy_died.emit()
		if cheer.playing:
			await cheer.finished
		queue_free()
	if wall_finder.is_colliding() && velocity.is_equal_approx(Vector2(velocity.x, 0)):
		velocity.y = -sqrt(-2*(GRAVITY/delta)*((get_wall_top_y()-position.y)-SAFETY_MARGIN	))
		if !airborne:
			animator.animation = "jump"
	move_and_slide()
	if !dead && inventory_manager.level.player in enemy_area.get_overlapping_bodies() && inventory_manager.level.active_buff == BaseLevel.Buffs.SLOW:
		speed = init_speed*0.75
	else:
		speed = init_speed
	if position.x >= inventory_manager.level.lose_axis.position.x:
		lose_subscriber()

func lose_subscriber() -> void:
	if !dead:
		inventory_manager.level.subscribers -= inventory_manager.level.subscribers*0.1
		var tween := get_tree().create_tween()
		tween.tween_property(inventory_manager.level.net_worth, "value", inventory_manager.level.net_worth.value + inventory_manager.level.net_worth.max_value*0.1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		inventory_manager.level.update_stats()
		if is_equal_approx(inventory_manager.level.net_worth.value, inventory_manager.level.net_worth.max_value) && inventory_manager.level.net_worth.max_value > 0:
			if inventory_manager.session_customers > StatsManager.stats["recruited_customers_unsaved"]:
				Save.change_setting("stats", "recruited_customers_unsaved", inventory_manager.session_customers)
			if inventory_manager.session_towers > StatsManager.stats["towers_placed_unsaved"]:
				Save.change_setting("stats", "towers_placed_unsaved", inventory_manager.session_towers)
			if inventory_manager.session_rickmechs > StatsManager.stats["defeated_rickmechs_unsaved"]:
				Save.change_setting("stats", "defeated_rickmechs_unsaved", inventory_manager.session_rickmechs)
			if inventory_manager.level.subscribers > StatsManager.stats["subscribers_unsaved"]:
				Save.change_setting("stats", "subscribers_unsaved", inventory_manager.level.subscribers)
			StatsManager.stats["subscribers_total"] = StatsManager.stats["subscribers_total"] + inventory_manager.level.subscribers
			StatsManager.save_stats()
			Save.change_setting("stats", "subscribers_total", + StatsManager.stats["subscribers_total"])
			TransitionManager.trans_to("res://scenes/UI/game over/game_over_screen.tscn")
			get_tree().paused = true
	dead = true

func on_mail_entered(body) -> void:
	if body is Mail:
		damage(body.damage)
		body.queue_free()
		
func damage(damage_points: float) -> void:
	hit.play()
	health -= damage_points
	if health <= 0:
		if not dead:
			cheer.play()
		dead = true
		inventory_manager.add_parts(parts_dropped, rank)
		StatsManager.stats["recruited_customers_total"] += 1
		inventory_manager.session_customers += 1
		StatsManager.save_stats()
		match StatsManager.stats["recruited_customers_total"]:
			1:
				AchievementManager.unlock("Encounter with the Enemy")
			50:
				AchievementManager.unlock("Gaining Traction")
			200:
				AchievementManager.unlock("Successful Businessman")
			999:
				AchievementManager.unlock("BIG SHOT")
			5000:
				AchievementManager.unlock("A Continent Under Control")
			99999:
				AchievementManager.unlock("A World Under Control")
	animator.modulate = Color.DARK_RED
	var tween := get_tree().create_tween()
	animator.modulate = Color.ROYAL_BLUE
	tween.tween_property(animator, "modulate", Color.WHITE, 0.2)
		
		
func get_wall_top_y() -> float:
	if not wall_finder.is_colliding():
		return INF
	
	var wall_hit_point = wall_finder.get_collision_point()
	var wall_normal = wall_finder.get_collision_normal()
	
	var offset_into_wall = -wall_normal * 4.0 
	var scan_x = wall_hit_point.x + offset_into_wall.x
	
	var max_jump_height = 200.0 
	var start_pos = Vector2(scan_x, global_position.y - max_jump_height)
	var end_pos = Vector2(scan_x, global_position.y) 
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	
	query.collision_mask = wall_finder.collision_mask 
	
	var result = space_state.intersect_ray(query)
	
	if result:
		return result["position"].y
	else:
		return INF
