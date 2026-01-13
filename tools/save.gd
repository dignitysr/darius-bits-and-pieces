extends Node

signal setting_changed(key: String, new_value: Variant)

const FILE_PATH: String = "user://settings.cfg"
var config := ConfigFile.new()

func _init() -> void:
	if not FileAccess.file_exists(FILE_PATH):
		config.save(FILE_PATH)

	var err: Error = config.load(FILE_PATH)

	if err != OK:
		push_error("Error loading config file!")

func load_setting(section: String, key: String, default: Variant) -> Variant:
	return config.get_value(section, key, default)

func change_setting(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)
	config.save(FILE_PATH)

	emit_signal(&"setting_changed", key, value)

func has_setting(section: String, key: String) -> bool:
	return config.has_section_key(section, key)
