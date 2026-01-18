extends CanvasLayer

var page: int = 1

func _ready():
	get_tree().paused = true
	for child in find_children("*"):
		match child.name:
			"Skip":
				child.connect("button_down", skip_pressed)
			"Next":
				child.connect("button_down", next_pressed)
			"Back":
				child.connect("button_down", back_pressed)
			"Close":
				child.connect("button_down", skip_pressed)
			"Restart":
				child.connect("button_down", restart_pressed)
				
func skip_pressed():
	get_tree().paused = false
	queue_free()
	
func next_pressed():
	page += 1
	update_page()
	
func back_pressed():
	page -= 1
	update_page()
	
func restart_pressed():
	page = 1
	update_page()
	
func update_page():
	for child in get_children():
		if not child is AudioStreamPlayer:
			if str(page) in child.name:
				child.show()
			else:
				child.hide()
				
