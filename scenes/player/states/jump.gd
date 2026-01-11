extends ActionState


@export var air_state: PhysicsState
@export var jump_power: float = 6.5
@export var jump_hold: float = 2
@export var fall_threshold: float = 3
@export var buffer_frames: int = 3

var jump_buffer: int = 0


## runs this check every frame while inactive and 
## in the character's current pool of states
func _startup_check() -> bool:
	return jump_buffer > 0


## runs this check every frame while active
## the string returned is the name of the state to change to
## return self.name for no change!
func _transition_check() -> String:
	if character.vel.y > fall_threshold or character.is_on_floor():
		return ""
	return name


## runs every frame while active
func _update() -> void:
	if air_state.in_air_counter <= 3 and character.vel.y < 0 and character.input["jump"][0]:
		character.vel.y -= jump_hold


## runs once when this state begins being active
func _on_enter() -> void:
	character.vel.y = -jump_power
	character.set_state("physics", air_state)


## always runs every frame while the game is unpaused 
func _physics_process(_delta: float) -> void:
	if jump_buffer > 0:
		jump_buffer -= 1
	
	if character.input["jump"][1]:
		jump_buffer = buffer_frames
