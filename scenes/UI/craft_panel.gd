extends PanelContainer

@onready var tower_texture: TextureRect = %TowerTexture

var object_list: ObjectList
var tower: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var objects: Dictionary = object_list.parts
	var tower_raw_texture: Texture2D = objects[tower].icon
	tower_texture.texture = ImageTexture.create_from_image(tower_raw_texture.get_image())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
