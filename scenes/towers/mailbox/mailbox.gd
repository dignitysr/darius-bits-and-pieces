extends BaseTower

func _attack() -> void:
	super()
	var mail_instance = mail.instantiate()
	mail_instance.position = spawner.global_position
	mail_instance.enemy = selected_enemy
	mail_instance.damage = damage
	owner.add_child(mail_instance)
