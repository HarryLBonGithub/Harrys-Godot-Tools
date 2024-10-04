extends Node

#this code takes player input and emits a signal depending on those inputs and wether or not the player is moving
signal pressed_jump(jump_state : JumpState)
signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@export var main_node : CharacterBody3D
@export var movement_states : Dictionary
@export var jump_states : Dictionary
@export var max_air_jump : int = 1
var air_jump_counter : int = 0

var movement_direction : Vector3

func _ready():
	set_movement_state.emit(movement_states["stand"])
	
func _input(event):
	if event.is_action("character movement"):
		movement_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		movement_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("run"):
				set_movement_state.emit(movement_states["run"])
			else:
				set_movement_state.emit(movement_states["walk"])
		else:
			set_movement_state.emit(movement_states["stand"])
		

func _physics_process(delta):
	# if moving, emit the direction of movement
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
	
	#jump input
	
	#double jump mechanics
	#set the jump count to 0 whenever the player is on the floor
	if main_node.is_on_floor():
		air_jump_counter = 0
	#did the player fall off a ledge without jumping? count that as one jump
	elif air_jump_counter == 0:
		air_jump_counter = 1
	
	if air_jump_counter <= max_air_jump:
		if Input.is_action_just_pressed("jump"):
			var jump_name = "ground_jump"
			
			if air_jump_counter > 0:
				jump_name = "air_jump"
			
			pressed_jump.emit(jump_states[jump_name])
			air_jump_counter += 1
	
func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
