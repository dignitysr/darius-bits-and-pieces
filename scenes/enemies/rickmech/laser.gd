class_name Laser
extends CharacterBody2D

const MOVE_SPEED = 300

@onready var collision = %Collision

var level: BaseLevel

var player_pos: Vector2
var direction: Vector2

func _ready() -> void:
	collision.connect("body_entered", on_darius_entered)
	direction = position.direction_to(player_pos)
	rotation = atan2((position.y - player_pos.y), (position.x - player_pos.x))

func _physics_process(_delta):
	velocity = direction * MOVE_SPEED

	move_and_slide()

func on_darius_entered(body) -> void:
	if body is Character:
		level.on_darius_death()
		get_parent().die(false)
