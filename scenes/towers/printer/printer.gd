class_name Printer
extends BaseTower

func _attack() -> void:
	super()
	inventory_manager.level.subscribers += pow(10.0, 3.0 + (0.6 * rank))
	inventory_manager.level.update_stats()
