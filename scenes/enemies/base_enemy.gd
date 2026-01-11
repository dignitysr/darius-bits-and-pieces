class_name BaseEnemy
extends CharacterBody2D

enum Rank {F, D, C, B, A, S}

@onready var pathplayer = $PathPlayer

@export_category("Enemy Info")
@export var enemy_name: String
@export var enemy_path: String = ""

@export_category("Enemy Stats")
@export var health: float = 100
@export var rank: Rank

func _ready():
	pathplayer.play(enemy_path)
