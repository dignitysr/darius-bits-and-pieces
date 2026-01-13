class_name BaseEnemy
extends CharacterBody2D

enum Rank {F, D, C, B, A, S}

@onready var pathplayer = $PathPlayer
@onready var enemy_area = %EnemyArea
@onready var animator = %Animator

var dead: bool = false
var dithering_intensity: float = 0

@export_category("Enemy Info")
@export var enemy_name: String
@export var enemy_path: String = ""

@export_category("Enemy Stats")
@export var health: float = 20
@export var rank: Rank
@export var death_speed: int = 4

func _ready() -> void:
	enemy_area.connect("body_entered", on_mail_entered)
	pathplayer.play(enemy_path)
	
func _physics_process(delta):
	if dead:
		animator.get_material().set_shader_parameter("intensity", dithering_intensity)
		dithering_intensity += delta*death_speed
	if dithering_intensity >= 1:
		queue_free()

func on_mail_entered(body: Mail) -> void:
	health -= body.damage
	body.queue_free()
	
	if health <= 0:
		dead = true
