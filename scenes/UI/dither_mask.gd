@tool
class_name DitherMask
extends TextureRect


const DITHER_TEXTURES: Array[Texture] = [
	preload("uid://bwxlbkxy0k1x7"),
	preload("uid://b508thr3b7o5h"),
	preload("uid://bsib5wx7vqwfu"),
	preload("uid://ci6vxywsa11cg"),
	preload("uid://dj2hn2eo5twqm"),
	preload("uid://d1wcmmhefgnha"),
	preload("uid://bcusyan48fi0j")
]

@export_range(0, 1, 0.05) var dither_percent: float = 1:
	set(new_value):
		dither_percent = new_value
		var index: int = int(float(DITHER_TEXTURES.size() - 1) * (1.0 - dither_percent))
		texture = DITHER_TEXTURES[index]
