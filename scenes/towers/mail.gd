class_name Mail
extends StaticBody2D

@export var rot_speed = 4

var enemy: BaseEnemy
var move_speed: float = 10
var damage: float

func _physics_process(_delta):
	if enemy.dead:
		queue_free()
	else:
		position = position.move_toward(enemy.position, move_speed)
	rotation_degrees += rot_speed
