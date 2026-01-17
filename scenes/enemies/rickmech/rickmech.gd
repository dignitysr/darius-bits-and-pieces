class_name Rickmech
extends StaticBody2D

const SHOOT_FREQ = 120

@onready var animator = %Animator
@onready var laser_arm = %LaserArm
@onready var laser_spawner = %LaserSpawner
@onready var stomp_collision = %StompCollision
@onready var ground_finder = %GroundFinder
@onready var enter_sfx = %EnterSFX
@onready var die_sfx = %DieSFX

@export var player: Character
@export var level: BaseLevel
@export var laser_scene: PackedScene
@export var parts_dropped: Dictionary[String, int]
@export var time_threshold: float = 300
@export var bounce_power: float = 4.5

var shoot_timer: float = 120
var move_sinusoidal: bool = false
var rest_position_y: float = 0
var run_time: float = 0
var time: float = 0

func _ready() -> void:
	animator.material.set_shader_parameter("intensity", 0)
	stomp_collision.connect("body_entered", on_stomped)
	var x_value: int = randi_range(0, level.x_range)
	position.x = x_value
	enter_sfx.play()
	ground_finder.force_raycast_update()
	await get_tree().create_timer(0.1).timeout
	if ground_finder.is_colliding():
		var tween := get_tree().create_tween()
		rest_position_y = ground_finder.get_collision_point().y - 50
		tween.tween_property(self, "position:y", rest_position_y, 4)
		tween.connect("finished", tween_finished)

func _physics_process(delta) -> void:
	laser_arm.look_at(player.position)
	laser_arm.rotation = clamp(laser_arm.rotation, -PI/2, PI/2)
	laser_arm.rotation = snapped(laser_arm.rotation, PI/12)
	animator.scale.x = sign(player.position.x - position.x)
	
	if move_sinusoidal:
		position.y = rest_position_y + 5*sin(time)
		time += delta*2
		
		if shoot_timer <= 0:
			var laser: Laser = laser_scene.instantiate()
			laser.player_pos = player.position
			laser.level = level
			laser.global_position = laser_spawner.global_position
			add_child(laser)
			shoot_timer = SHOOT_FREQ
		else:
			shoot_timer -= 1
	
func tween_finished() -> void:
	move_sinusoidal = true
	
func on_stomped(body) -> void:
	if body is Character:
		body.vel.y = -bounce_power
		die()
	
func die(killed: bool = true) -> void:
	var dither: float = 0
	move_sinusoidal = false
	while dither < 1:
		animator.material.set_shader_parameter("intensity", dither)
		dither += 0.02
		await get_tree().physics_frame
	if killed:
		StatsManager.stats["defeated_rickmechs_total"] += 1
		level.inventory_manager.session_rickmechs += 1
		StatsManager.save_stats()
		level.add_parts(parts_dropped, int(run_time/time_threshold), false)
	else:
		die_sfx.play()
	queue_free()
