class_name ToteBag
extends BaseTower

@export var speed: float = 20
@export var gravity: float = 10
@export var amp: int = 8
@export var freq: int = 6

func _ready():
	super()

func _physics_process(delta) -> void:
	super(delta)
	if position.x > inventory_manager.level.x_range || position.x < 0:
		speed = -speed
	velocity.x = speed
	
	if !is_on_floor():
		move_and_slide()
		if !broken:
			position.y = amp*sin(position.x/freq)
	
	if broken:
		velocity.y += gravity
		
	if dithering_intensity > 0:
		set_collision_mask_value(1, 0)

func _attack() -> void:
	super()
	var mail_instance = mail.instantiate()
	mail_instance.position = spawner.global_position
	mail_instance.enemy = selected_enemy
	mail_instance.damage = damage
	inventory_manager.add_child(mail_instance)
