class_name BreakingNews
extends Control


@onready var label: Label = %Label
@export var text_move_speed: float = 0.5

func _ready() -> void:
	hide()
	modulate.a = 0
	show_news("Local Darius the Mailman gets hit by truck and fucking dies. More at 10.")
	
func show_news(news: String) -> void:
	show()
	var default_text_pos = get_viewport_rect().size.x
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	label.text = news
	label.position.x = default_text_pos
	while label.position.x >= -label.size.x:
		label.position.x -= text_move_speed
		await get_tree().process_frame
	await get_tree().create_timer(1).timeout
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	hide()
