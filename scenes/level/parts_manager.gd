class_name InventoryManager
extends Node2D

enum Rank {F, D, C, B, A, S}

@export var recipes: Recipes
@export var object_list: ObjectList
@export var ranks_resource: RanksResource
@export var small_ranks_resource: RanksResource
@export var craftable_panel: PackedScene

@onready var craft_trans_button: Button = %CraftTransButton
@onready var trans_player: AnimationPlayer = %TransitionPlayer
@onready var craftable_container: VBoxContainer = %CraftableContainer
@onready var preview: Sprite2D = %Preview
@onready var craft_container: HBoxContainer = %CraftContainer
@onready var place_validator: RayCast2D = %PlaceValidator

var tower_placed: bool = false

## Notation is:
## {Part name: {
## Rank: Number,
## Rank: Number},
## Part name: etc}
var parts: Dictionary = {
	"paper": {Rank.S: 5, Rank.A: 4, Rank.B: 2, Rank.C: 63454213454, Rank.F: 5}, 
	"scrap": {Rank.S: 3, Rank.A: 5, Rank.B: 2, Rank.C: 3, Rank.F: 5}}
	
func _ready() -> void:
	craft_trans_button.connect("button_down", on_craft_trans_pressed)
	preview.hide()
	
func on_craft_trans_pressed() -> void:
	if !craft_trans_button.button_pressed:
		refresh_recipes()
		trans_player.play("craft_trans")
	else:
		trans_player.play_backwards("craft_trans")
		
func refresh_recipes() -> void:
	for child in craftable_container.get_children():
		child.queue_free()
	var valid_recipes = good_util.get_valid_recipes(recipes, parts)
	for recipe: String in valid_recipes:
		if valid_recipes.keys().find(recipe) + 1 == valid_recipes.keys().size():
			instance_craftable(recipe, valid_recipes[recipe])
		else:
			instance_craftable(recipe, valid_recipes[recipe])

func instance_craftable(recipe: String, valid_ranks: Array) -> void:
	var craftable = craftable_panel.instantiate()
	craftable.object_list = object_list
	craftable.inventory = self
	craftable.recipes = recipes
	craftable.ranks_resource = ranks_resource
	craftable.small_ranks_resource = small_ranks_resource
	craftable.tower = recipe
	craftable.valid_recipes = valid_ranks
	craftable_container.add_child(craftable)
	craftable_container.add_child(HSeparator.new())
	
func buy(tower: String, rank: Rank) -> void:
	craft_container.hide()
	preview.show()
	while !tower_placed:
		preview.global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("back"):
			preview.hide()
			craft_container.show()
			tower_placed = true
		if place_validator.is_colliding():
			preview.self_modulate = Color.GREEN
			if Input.is_action_just_pressed("click"):
				place_tower(tower, rank)
		else:
			preview.self_modulate = Color.RED
		await get_tree().physics_frame
	tower_placed = false
	preview.global_position = Vector2.ZERO
		
func place_tower(tower: String, rank: int):
	var tower_scene: BaseTower = object_list.parts[tower].scene.instantiate()
	tower_scene.inventory_manager = self
	tower_scene.global_position = place_validator.get_collision_point()
	@warning_ignore("int_as_enum_without_cast")
	tower_scene.rank = rank
	for part: String in recipes.recipes[tower]:
		parts[part][rank] -= recipes.recipes[tower][part]
	preview.hide()
	craft_container.show()
	tower_placed = true
	get_parent().add_child(tower_scene)
	refresh_recipes()
