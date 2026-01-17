extends AnimatedSprite2D


@onready var animator: AnimatedSprite2D = get_parent()


func _process(_delta: float) -> void:
	animation = animator.animation
	frame = animator.frame
	flip_h = animator.flip_h
	flip_v = animator.flip_v
