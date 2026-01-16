extends BaseMenu

@onready var return_button = %Return

func _ready():
	return_button.connect("button_down", return_button_pressed)
	print(owner)
	if !owner is MenuController:
		dither(1, 0)
	
func return_button_pressed() -> void:
	if owner is MenuController:
		trans_to("MainMenu")
	else:
		await dither(0, 1)
		get_tree().paused = false
		queue_free()
		
		
func dither(from: int, to: int) -> void:
	var dither_intensity: float = from
	while abs(dither_intensity - to) > 0.03:
		material.set_shader_parameter("intensity", dither_intensity)
		dither_intensity += 0.03 * (to-from)
		await get_tree().process_frame
	
