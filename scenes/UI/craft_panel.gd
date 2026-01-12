class_name CraftablePanel
extends PanelContainer

@onready var tower_texture: TextureRect = %TowerTexture
@onready var name_label: Label = %Name
@onready var quantity_container: VBoxContainer = %QuantityContainer
@onready var rank_selection_button: Button = %RankSelectButton
@onready var ranks_container: VBoxContainer = %RanksContainer
@onready var name_panel: Control = %NamePanel
@onready var rank_panel: Control = %RankPanel

@export var quantity_label_scene: PackedScene
@export var rank_scene: PackedScene

@export var inventory: InventoryManager

@export var object_list: ObjectList
@export var recipes: Recipes
@export var ranks_resource: RanksResource


var tower: String = "mailbox"
var valid_recipes: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rank_selection_button.connect("button_down", on_rank_selection_pressed)
	name_label.text = tower.capitalize()
	tower_texture.texture = direct_image(object_list.parts[tower].icon)
	
	for part: String in recipes.recipes[tower]:
		populate_part(part, quantity_container, recipes.recipes[tower][part])

func direct_image(texture: Texture2D) -> ImageTexture:
	var image = texture.get_image()
	return ImageTexture.create_from_image(image)

func populate_part(part: String, parent: Control, amount: int) -> void:
	var quantity_label = quantity_label_scene.instantiate()
	quantity_label.icon_texture = direct_image(object_list.parts[part].icon)
	quantity_label.amount = amount
	parent.add_child(quantity_label)
	
func populate_rank(rank: int) -> void:
	var rank_panel = rank_scene.instantiate()
	rank_panel.craft_panel = self
	rank_panel.inventory = inventory
	rank_panel.ranks_resource = ranks_resource
	rank_panel.rank = rank
	ranks_container.add_child(rank_panel)

func on_rank_selection_pressed() -> void:
	for rank: int in valid_recipes:
		populate_rank(rank)
	name_panel.hide()
	rank_panel.show()
