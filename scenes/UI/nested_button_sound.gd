extends ButtonSound


func _ready() -> void:
	hover_sound = owner.get_parent().get_node_or_null(hover_name)
	press_sound = owner.get_parent().get_node_or_null(press_name)
	super()
