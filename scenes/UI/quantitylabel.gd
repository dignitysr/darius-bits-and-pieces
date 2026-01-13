extends Control

@onready var icon: TextureRect = %Icon
@onready var amount_label: Label = %Amount
@onready var rank_texture = %Rank

var icon_texture: ImageTexture
var amount: int
var rank


func _ready() -> void:
	icon.texture = icon_texture
	amount_label.text = "x" + math_util.convert_num(amount)
	if is_instance_valid(rank):
		rank_texture.texture = rank
