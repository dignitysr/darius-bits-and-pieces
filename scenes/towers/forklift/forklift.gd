class_name Forklift
extends BaseTower

@onready var home: Area2D = %Home
@onready var inner_enemy_detection: Area2D = $EnemyDetection

@export var speed: float = 0.3


func _ready():
	super()
	home.position = position
	enemy_detection = home

func _physics_process(delta) -> void:
	super(delta)
	if is_instance_valid(selected_enemy):
		animator.flip_h = selected_enemy.position.x > position.x
		position = position.move_toward(Vector2(selected_enemy.position.x, position.y), speed)
	move_and_slide()
	
func _attack() -> void:
	for enemy_area: Area2D in inner_enemy_detection.get_overlapping_areas():
		if enemy_area.get_parent() is BaseEnemy:
			durability -= 1
			enemy_area.get_parent().damage(damage)
