class_name Fox
extends BaseEnemy

@export var char_jump_pow: float

func _physics_process(delta):
	super(delta)
	if is_on_floor():
		velocity.y = -char_jump_pow
