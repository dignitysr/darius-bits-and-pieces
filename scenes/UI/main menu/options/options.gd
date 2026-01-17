extends BaseMenu


@onready var return_button = %Return
@onready var dither_mask: DitherMask = %DitherMask

func _ready():
	return_button.connect("button_down", return_button_pressed)
	
func return_button_pressed() -> void:
	if owner is MenuController:
		trans_to("MainMenu")
	else:
		await dither(1, 0)
		get_tree().paused = false
		hide()
		
		
func dither(from: int, to: int) -> void:
	var dither_intensity: float = from
	while abs(dither_intensity - to) > 0.03:
		dither_mask.dither_percent = dither_intensity
		dither_intensity += 0.03 * (to-from)
		await get_tree().process_frame
	
