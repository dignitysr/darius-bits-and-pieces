class_name Rickmech
extends StaticBody2D

const SHOOT_FREQ = 120

@onready var animator = %Animator
@onready var laser_arm = %LaserArm
@onready var laser_spawner = %LaserSpawner
@onready var stomp_collision = %StompCollision
@onready var ground_finder = %GroundFinder
@onready var sfx = %SFX

@export var player: Character
@export var level: BaseLevel
@export var laser_scene: PackedScene

var shoot_timer: float = 120
var move_sinusoidal: bool = false
var rest_position_y: float = 0

var time: float = 0

func _ready() -> void:
	animator.material.set_shader_parameter("intensity", 0)
	var x_value: int = randi_range(0, level.x_range)
	position.x = x_value
	sfx.play()
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
	
func die(killed: bool = true) -> void:
	var dither: float = 0
	while dither < 1:
		animator.material.set_shader_parameter("intensity", dither)
		dither += 0.02
		await get_tree().physics_frame
	if killed:
		StatsManager.stats["defeated_rickmechs_total"] += 1
		StatsManager.stats["defeated_rickmechs"] += 1
	queue_free()
