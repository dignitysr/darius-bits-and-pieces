class_name RankCraftablePanel
extends PanelContainer

@onready var buy_button: Button = %BuyButton
@onready var rank_texture_node: TextureRect = %RankTexture
@onready var rank_shadow: TextureRect = %RankShadow
@onready var quality_container: VBoxContainer = %QualityContainer
@onready var tower_texture_node: TextureRect = %TowerTexture
@onready var tower_shadow: TextureRect = %TowerShadow

var craft_panel: CraftablePanel
var inventory: InventoryManager
var object_list: ObjectList
var ranks_resource: RanksResource
var rank: InventoryManager.Rank

func _ready() -> void:
	buy_button.connect("button_down", buy_item)
	var recipes = craft_panel.recipes.recipes
	var tower = craft_panel.tower
	rank_texture_node.texture = good_util.direct_image(ranks_resource.ranks[rank])
	rank_shadow.texture = rank_texture_node.texture
	tower_texture_node.texture = good_util.direct_image(object_list.parts[tower].icon)
	tower_shadow.texture = tower_texture_node.texture
	for part: String in recipes[tower]:
		craft_panel.populate_part(part, quality_container, inventory.parts[part][rank], rank)
		
func buy_item() -> void:
	inventory.buy(craft_panel.tower, rank)
