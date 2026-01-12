class_name InventoryManager
extends Node

enum Rank {F, D, C, B, A, S}

@export var recipes: Recipes
@export var object_list: ObjectList
@export var ranks_resource: RanksResource
@export var craftable_panel: PackedScene

@onready var craft_trans_button: Button = %CraftTransButton
@onready var trans_player: AnimationPlayer = %TransitionPlayer
@onready var craftable_container: VBoxContainer = %CraftableContainer

## Notation is:
## {Part name: {
## Rank: Number,
## Rank: Number},
## Part name: etc}
var parts: Dictionary = {
	"paper": {Rank.S: 5, Rank.A: 4, Rank.B: 2, Rank.C: 99}, 
	"scrap": {Rank.S: 3, Rank.A: 5, Rank.B: 2, Rank.C: 3}}
	
func _ready() -> void:
	craft_trans_button.connect("button_down", on_craft_trans_pressed)
	
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
			instance_craftable(recipe, valid_recipes[recipe], true)
		else:
			instance_craftable(recipe, valid_recipes[recipe], false)

func instance_craftable(recipe: String, valid_ranks: Array, is_final: bool) -> void:
	var craftable = craftable_panel.instantiate()
	craftable.object_list = object_list
	craftable.inventory = self
	craftable.recipes = recipes
	craftable.ranks_resource = ranks_resource
	craftable.tower = recipe
	craftable.valid_recipes = valid_ranks
	craftable_container.add_child(craftable)
	craftable_container.add_child(HSeparator.new())
