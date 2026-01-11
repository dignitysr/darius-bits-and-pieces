class_name CharacterAnimator
extends AnimatedSprite2D


var character: Character
func _enter_tree() -> void:
	character = get_owner()

func _physics_process(_delta: float) -> void:
	reset_physics_interpolation()

func update() -> void:
	var new_anim: String
	var sprite_offset: Vector2i
	var sprite_rot: float
	var sprite_skew: float
	var sprite_scale := Vector2.ONE
	
	if is_instance_valid(character.action):
		new_anim = character.action.animation
		sprite_offset = character.action.sprite_offset
		sprite_rot = character.action.sprite_rot
		sprite_skew = character.action.sprite_skew
		sprite_scale = character.action.sprite_scale
	
	if is_instance_valid(character.physics):
		if new_anim == "":
			new_anim = character.physics.animation
			sprite_offset = character.physics.sprite_offset
		
		sprite_rot += character.physics.sprite_rot
		sprite_skew += character.physics.sprite_skew
		sprite_scale *= character.physics.sprite_scale
	
	flip_h = (character.facing_dir < 0)
	offset = sprite_offset
	rotation = sprite_rot
	skew = sprite_skew
	scale = sprite_scale
	
	
	if new_anim == "":
		if is_playing(): 
			stop()
	elif animation != new_anim:
		play(new_anim)
