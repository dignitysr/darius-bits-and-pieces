class_name PartsManager
extends Node

enum Rank {F, D, C, B, A, S}

@export var parts_list: PartsList

## Notation is:
## {Part name: {
## Rank: Number,
## Rank: Number},
## Part name: etc}
var parts: Dictionary = {}
