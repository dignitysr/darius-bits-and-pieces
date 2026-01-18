extends CanvasLayer


@onready var wild_jam: Control = $WildJam
@onready var wild_player: AnimationPlayer = wild_jam.get_node("AnimationPlayer")

func _ready() -> void:
	await get_tree().process_frame
	
	wild_jam.show()
	wild_player.play("splash")
