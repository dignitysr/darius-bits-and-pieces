class_name QuantityLabel
extends BoxContainer

@onready var icon: TextureRect = %Icon
@onready var icon_shadow: TextureRect = %IconShadow
@onready var amount_label: Label = %Amount
@onready var rank_texture = %Rank
@onready var rank_shadow: TextureRect = %RankShadow

@export var icon_texture: ImageTexture
var amount: int
var rank


func _ready() -> void:
	icon.texture = icon_texture
	icon_shadow.texture = icon.texture
	amount_label.text = "x" + math_util.convert_num(amount)
	if is_instance_valid(rank):
		rank_texture.texture = rank
		rank_shadow.texture = rank_texture.texture
