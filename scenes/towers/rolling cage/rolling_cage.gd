class_name RollingCage
extends BaseTower

@export var speed: float = 20

func _physics_process(delta) -> void:
	super(delta)
	if is_on_wall():
		speed = -speed
	velocity.x = speed
	move_and_slide()

func _attack() -> void:
	super()
	selected_enemy.damage(damage)
