extends PhysicsState


@export var move_speed: float = 8
@export var ground_state: PhysicsState

@export_group("Acceleration")
@export var accel_div: float = 50
@export var accel_damp: float = 99
@export var accel_add: float = 0.5
@export var friction_div: float = 12
@export var unrotate_speed: float = 4

@export_group("Counters")
@export var in_air_counter: float = 0


## runs this check every frame while inactive and 
## in the character's current pool of states
func _startup_check() -> bool:
	return true


## runs this check every frame while active
## the string returned is the name of the state to change to
## return self.name for no change!
func _transition_check() -> String:
	if character.is_on_floor():
		return ground_state.name
	return name


## runs every frame while active
func _update() -> void:
	if character.inventory_manager.level.active_buff == BaseLevel.Buffs.FASTER:
		move_speed = 4
	else:
		move_speed = 2
	character.vel.y = math_util.apply_gravity(character.vel.y)
	
	var move_dir: int = 0
	if character.input["left"][0]:
		move_dir -= 1
	if character.input["right"][0]:
		move_dir += 1
	
	if move_dir != 0:
		character.facing_dir = move_dir
		
		if ((move_dir == 1 and character.vel.x < move_speed) 
		or (move_dir == -1 and character.vel.x > -move_speed)):
			character.vel.x += accel_add * move_dir
		
		var gain: float = move_speed * move_dir
		character.vel.x += (gain - character.vel.x) * math_util.ease(accel_div)
		character.vel.x *= math_util.friction(accel_damp)
	else:
		character.vel.x *= math_util.friction(friction_div)
	if character.vel.y > 0:
		animation = "fall"
	else:
		animation = "jump"
	
	in_air_counter += 1


## runs once when this state begins being active
func _on_enter() -> void:
	in_air_counter = 0
	sprite_rot = ground_state.sprite_rot
	while !is_equal_approx(sprite_rot, 0):
		sprite_rot = lerp_angle(sprite_rot, 0, math_util.FIXED_DELTA*unrotate_speed)
		await get_tree().process_frame
	sprite_rot = 0


## runs once when this state stops being active
func _on_exit() -> void:
	ground_state.sprite_rot = 0
	in_air_counter = 0
