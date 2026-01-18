extends BaseEnemy

func damage(damage_points: float) -> void:
	super(damage_points)
	if health <= 0:
		if inventory_manager.level.wave_resource.name == "Mailopolis" && inventory_manager.level.wave_number == 18:
			AchievementManager.unlock("Knighted")
