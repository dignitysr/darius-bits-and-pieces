class_name RollingCage
extends BaseTower

const GRAVITY = 10

@export var speed: float = 20

func _physics_process(delta) -> void:
	super(delta)
	if is_on_wall():
		speed = -speed
	if !is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0
	velocity.x = speed
	move_and_slide()

func _attack() -> void:
	super()
	selected_enemy.damage(damage)
