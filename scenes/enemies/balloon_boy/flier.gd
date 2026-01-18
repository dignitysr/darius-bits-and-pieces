extends BaseEnemy

func damage(damage_points: float) -> void:
	super(damage_points)
	#if health <= 0:
		#inventory_manager.level.achievement_flags["Balloon/UFO defeated"] = true
