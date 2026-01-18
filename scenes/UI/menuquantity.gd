extends QuantityLabel

@export var image: Texture2D
@export var inventory_manager: InventoryManager

func _ready() -> void:
	inventory_manager.connect("changed_parts", show_parts)
	icon_texture = good_util.direct_image(image)
	var total_parts: int = 0
	for part_rank in inventory_manager.parts[name.to_lower()]:
		total_parts += inventory_manager.parts[name.to_lower()][part_rank]
	amount = total_parts
	super()

func show_parts():
	_ready()
