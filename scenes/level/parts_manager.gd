class_name InventoryManager
extends Node

enum Rank {F, D, C, B, A, S}

@export var parts_list: PartsList
@export var recipes: Recipes

## Notation is:
## {Part name: {
## Rank: Number,
## Rank: Number},
## Part name: etc}
var parts: Dictionary = {
	"paper": {Rank.S: 3, Rank.A: 5, Rank.B: 2, Rank.C: 5}, 
	"scrap": {Rank.S: 3, Rank.A: 5, Rank.B: 2, Rank.C: 3}}
	
