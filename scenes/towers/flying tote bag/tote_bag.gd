class_name ToteBag
extends BaseTower

@export var speed: float = 10
@export var gravity: float = 10

func _ready():
	super()
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position:y", 0, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _physics_process(delta) -> void:
	super(delta)
	if position.x > inventory_manager.level.x_range || position.x < 0:
		speed = -speed
	velocity.x = speed
	
	if !is_on_floor():
		move_and_slide()
	
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
