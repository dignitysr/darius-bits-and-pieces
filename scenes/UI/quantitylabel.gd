extends Control

@onready var icon: TextureRect = %Icon
@onready var amount_label: Label = %Amount

var icon_texture: ImageTexture
var amount: int


func _ready() -> void:
	icon.texture = icon_texture
	amount_label.text = "x" + str(amount)
