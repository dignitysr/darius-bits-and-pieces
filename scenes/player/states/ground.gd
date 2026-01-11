extends PhysicsState


@export var move_speed: float = 8
@export var coyote_frames: int = 2
@export var air_state: PhysicsState
@export var walk_windup_length: float = 1.4
@export var rotation_manager: RotationManager

@export_group("Acceleration")
@export var ice_accel_div: float = 34
@export var accel_div: float = 4
@export var rotate_speed: float = 16

@export_group("Friction")
@export var ice_friction_div: float = 60
@export var friction_div: float = 6
@export var ice_friction_sub: float = 0.02
@export var friction_sub: float = 0.5

const CROUCH_ANIM_LENGTH: float = 0.08

var allow_anim: bool = true

## runs this check every frame while inactive and 
## in the character's current pool of states
func _startup_check() -> bool:
	return character.is_on_floor()


## runs this check every frame while active
## the string returned is the name of the state to change to
## return self.name for no change!
func _transition_check() -> String:
	if not character.is_on_floor():
		character.container_override = self
		character.override_frames = coyote_frames
		return air_state.name
	return name


## runs every frame while active
func _update() -> void:
	character.vel.y = min(character.vel.y + 1.0, 1.0)
	
	var move_dir: int = 0
	if character.input["left"][0]:
		move_dir -= 1
	if character.input["right"][0]:
		move_dir += 1
	
	if character.is_on_wall() and sign(character.get_wall_normal().x) == -move_dir:
		move_dir = 0
	
	if move_dir != 0:
		character.facing_dir = move_dir
		var accel: float = ice_accel_div if character.on_ice else accel_div
		var gain: float = move_speed * move_dir
		character.vel.x += (gain - character.vel.x) * math_util.ease(accel)
		if allow_anim && !is_equal_approx(character.vel.x, 0.0):
			animation = "walk"
	else:
		var friction: float = ice_friction_div if character.on_ice else friction_div
		var subtract: float = ice_friction_sub if character.on_ice else friction_sub
		character.vel.x *= math_util.friction(friction)
		character.vel.x = move_toward(character.vel.x, 0, subtract)
	if character.vel.is_equal_approx(Vector2(0, character.vel.y)) && allow_anim:
		animation = "idle"
		
func _physics_process(_delta: float) -> void:
	if animation != "idle":
		sprite_rot = lerp_angle(sprite_rot, -rotation_manager.angle, math_util.FIXED_DELTA*rotate_speed)
		
		
func _on_enter() -> void:
	if character.vel.x > 0:
		animation = "walk"
	while !is_equal_approx(abs(sprite_rot), rotation_manager.angle):
		sprite_rot = lerp_angle(sprite_rot, -rotation_manager.angle, math_util.FIXED_DELTA*rotate_speed)
		await get_tree().physics_frame
