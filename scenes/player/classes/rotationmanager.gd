class_name RotationManager
extends Node

@export var character: Character
@export var raycast: RayCast2D

const UP = Vector2(0, 1)

var angle: float = 0

func _process(_delta: float) -> void:
	angle = clamp(raycast.get_collision_normal().angle_to(Vector2.UP), -0.7, 0.7)
