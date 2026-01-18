class_name AudiovisualOptions
extends Control

enum FPS {VSYNC, UNCAPPED, SIXTY, THIRTY, FIFTEEN, DISABLE}
enum SCALE {ONE, TWO, THREE, FULL}

@export var default_window_scale: Vector2

var editable_options: Dictionary

func _ready():
	for child in find_children("*"):
		if child is Slider:
			editable_options[child.name] = child
			child.value = Save.load_setting("options", child.name, 1)
			slider_changed(child.value, child.name)
			child.connect("value_changed", slider_changed.bind(child.name))
		elif child is OptionButton:
			child.get_popup().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
			editable_options[child.name] = child
			child.connect("item_selected", option_selected.bind(child.name))
			child._select_int(Save.load_setting("options", child.name, 0))
			if OS.get_name() == "Web":
				if child.name != "WindowScale":
					option_selected(Save.load_setting("options", child.name, 0), child.name)
				else:
					child.remove_item(1)
					child.remove_item(1)
			else:
				if child.name != "WindowScale" or owner.get_parent().owner.name == "MenuController":
					option_selected(Save.load_setting("options", child.name, 0), child.name)


func slider_changed(value: float, slider: String) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(slider), linear_to_db(value))
	Save.change_setting("options", slider, value)

func option_selected(index: int, option: String) -> void:
	if index != FPS.DISABLE:
		Save.change_setting("options", option, index)
	if option == "FPS":
		match index:
			FPS.VSYNC:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			FPS.UNCAPPED:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
				Engine.max_fps = 0
			FPS.SIXTY:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
				Engine.max_fps = 60
			FPS.THIRTY:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
				Engine.max_fps = 30
			FPS.FIFTEEN:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
				Engine.max_fps = 30
			FPS.DISABLE:
				get_tree().quit()
	elif option == "WindowScale":
		if OS.get_name() == "Web":
			match index:
				SCALE.ONE:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					get_window().size = default_window_scale*2
				SCALE.TWO:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			match index:
				SCALE.ONE:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					get_window().size = default_window_scale
				SCALE.TWO:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					get_window().size = default_window_scale*1.5
				SCALE.THREE:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					get_window().size = default_window_scale*2
				SCALE.FULL:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
