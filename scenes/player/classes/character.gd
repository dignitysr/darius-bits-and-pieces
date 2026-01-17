class_name Character
extends CharacterBody2D


## using this variable instead of the in-built one because
## godot uses delta in its calculations and LL does not, so we need
## to account for that before applying it
var vel: Vector2
var facing_dir: int = 1
var input: Dictionary

@export var inventory_manager: InventoryManager

### Attributes
@export var on_ice: bool

### Nodes
@onready var animator: CharacterAnimator = $Sprite
@onready var physics_states: Node = $PhysicsStates
@onready var sprite_overlay = %SpriteOverlay
@onready var camera = %Camera2D

### States
@onready var physics: PhysicsState
var action: ActionState

# the below is used for coyote time; when the ground state transitions 
# to the air state, it'll set an override for a few frames so you
# can still do ground actions even if you're slightly late
var container_override: PhysicsState
var override_frames: int

func _ready() -> void:
	sprite_overlay.modulate = Color(randf(), randf(), randf(), 1)
	sprite_overlay.visible = inventory_manager.level.darius_name != "Darius the Mailman"

func set_state(type: String, state: CharacterState) -> void:
	var old_state: CharacterState = self[type]
	if is_instance_valid(old_state):
		old_state._on_exit()
	
	self[type] = state
	
	if is_instance_valid(state):
		state._on_enter()


func check_startups(cur_state: CharacterState, container: Node) -> CharacterState:
	var cur_priority: int = -1
	if is_instance_valid(cur_state): cur_priority = cur_state.priority
	for check_state: CharacterState in container.get_children():
		if check_state.priority > cur_priority:
			if check_state._startup_check():
				return check_state
	return null


func update_states(type: String, container: Node) -> void:
	## handle updates, transitions
	var cur_state: CharacterState = self[type]
	if is_instance_valid(cur_state):
		var transition_to: String = cur_state._transition_check()
		if transition_to == cur_state.name:
			cur_state._update()
		elif is_instance_valid(container) and container.has_node(transition_to):
			set_state(type, container.get_node(transition_to))
		else:
			set_state(type, null)
	
	## handle startups
	if is_instance_valid(container):
		var startup_state: CharacterState = check_startups(self[type], container)
		if is_instance_valid(startup_state):
			set_state(type, startup_state)


### Logic
func _physics_process(delta: float) -> void:
	input = get_input()
	
	update_states("physics", physics_states)
	
	var container: PhysicsState = physics
	if override_frames > 0:
		override_frames -= 1
		container = container_override
		if override_frames <= 0: container_override = null
	
	update_states("action", container)
	
	animator.update()
	
	up_direction = Vector2.UP.rotated(rotation)
	velocity = (vel / delta).rotated(rotation)
	move_and_slide()
	vel = (velocity * delta).rotated(-rotation)
	
	sprite_overlay.flip_h = animator.flip_h


### Input
var inputs_list: Array = [
	"down",
	"left",
	"right",
	"jump",
	"click",
]
func get_input() -> Dictionary:
	var new_input: Dictionary = {}
	
	for action_name: String in inputs_list:
		var pressed: bool = Input.is_action_pressed(action_name)
		var just_pressed: bool = Input.is_action_just_pressed(action_name)
		new_input[action_name] = [pressed, just_pressed]
	
	return new_input
