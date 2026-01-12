class_name RankCraftablePanel
extends PanelContainer

enum Rank {F, D, C, B, A, S}

@onready var buy_button: Button = %BuyButton
@onready var rank_texture_node: TextureRect = %RankTexture
@onready var quality_container: VBoxContainer = %QualityContainer

var craft_panel: CraftablePanel
var inventory: InventoryManager
var ranks_resource: RanksResource
var rank: Rank

func _ready() -> void:
	var recipes = craft_panel.recipes.recipes
	var tower = craft_panel.tower
	rank_texture_node.texture = craft_panel.direct_image(ranks_resource.ranks[rank])
	for part: String in recipes[tower]:
		craft_panel.populate_part(part, quality_container, inventory.parts[part][rank])
