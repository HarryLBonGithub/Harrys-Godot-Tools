extends Node

#this code takes player input and emits a signal depending on those inputs and wether or not the player is moving
signal pressed_jump(jump_state : JumpState)
signal changed_stance(stance : StanceState)
signal changed_movement_state(_movement_state: MovementState)
signal changed_movement_direction(_movement_direction: Vector3)
signal changed_tool_state(_tool_state: String)
signal strafing_toggle(_strafing: bool)
signal combat_mode_toggle(_combat_mode: bool)
signal tool_use(_anim: String)
signal tool_melee()
signal strafe_high(high)

@export var main_node : CharacterBody3D
@export var movement_states : Dictionary
@export var jump_states : Dictionary
@export var stances : Dictionary

@export var max_air_jump : int = 1

@export var movement_enabled : bool = true
@export var jump_enabled : bool = true
@export var crouch_enabled : bool = true
@export var prone_enabled : bool = true
@export var run_enabled : bool = true
@export var aim_enabled : bool = true


@onready var main_collider = $"../UprightCollider"
@onready var mesh_root = $"../MeshRoot"

var air_jump_counter : int = 0
var current_stance_name : String = "upright"
var current_movement_state_name : String
var stance_antispam_timer : SceneTreeTimer
var is_strafing = false #my strafing addition
var alert = false
var current_tool_state = "ready"
var combat_mode = false
var can_use_tool = true
var strafing_high = true

var movement_direction : Vector3
var height_tween : Tween

func _ready():
	set_movement_state("stand")

func _input(event):
	
	if not movement_enabled:
		return
	#sets the movement direction and changes the animation to match
	#sets this based on a state, each stance has a series of states 
	if event.is_action_pressed("character movement") or event.is_action_released("character movement"):
		movement_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		movement_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		changed_movement_direction.emit(movement_direction)
		
		# sets the movement speed and camera focus. Cannot change if the player is currently aiming/strafing
		if is_movement_ongoing():
			if Input.is_action_pressed("run") and run_enabled and is_strafing == false:
				set_movement_state("run")
			else:
				set_movement_state("walk")
		else:
			set_movement_state("stand")
			
	#toggle strafing movement and aim weapon
	#strafing is a snace on the same level as alert/upright/crouch/prone
	#checks if the player is not prone, and on the floor. this means the player will pop up to aim if they are currently crouched
	#makes the player able to use a tool while aiming
	if (current_stance_name !="prone") and main_node.is_on_floor():
	
		if Input.is_action_just_pressed("aim") and can_aim():
			strafing_toggle.emit(true)
			set_stance("strafing")
			set_tool_state("aim")
			is_strafing = true
		elif Input.is_action_just_released("aim") and aim_enabled:
			strafing_toggle.emit(false)
			if strafing_high == false:
				set_stance("crouch")
			else:
				if alert == true:
					set_stance("alert")
				else:
					set_stance("upright")
			set_tool_state("ready")
			is_strafing = false

	#tool calls
	#if the tool-state is 'ready' the player will activate the current 'melee' animation
	#if the tool-state is 'aim' the player will activate the primary 'use' function and the current 'use' animation
	if Input.is_action_pressed("use_tool") and can_use_tool:
		if current_tool_state == "ready":
			fire_tool_melee()
		else:
			fire_tool_oneshot("use")
	#plays the current reload animation
	if Input.is_action_just_pressed("reload"):
		fire_tool_oneshot("reload")

	#stance change up
	#if the player is not aiming, they will ascend through stances based on their current one
	#prone -> crouch -> upright/alert -> jump
	#this changes stances
	if Input.is_action_just_pressed("jump") and main_node.is_on_floor():
		if current_stance_name == "upright" or current_stance_name == "alert":
			#jump input	
			if not jump_enabled:
				return
			if Input.is_action_just_pressed("jump"):
				if air_jump_counter <= max_air_jump:
					var jump_name = "ground_jump"
					
					if air_jump_counter > 0:
						jump_name = "air_jump"
					
					pressed_jump.emit(jump_states[jump_name])
					air_jump_counter += 1
		elif current_stance_name == "crouch":
			if alert == true:
				set_stance("alert")
			else:
				set_stance("upright")
		elif current_stance_name == "prone":
			set_stance("crouch")
		
	#stance change down
	#if the player is not aiming, they will descend through stances based on their current one
	#upright/alert -> crouch -> prone
	#this changes stances
	if Input.is_action_just_pressed("crouch") and main_node.is_on_floor():
		if (current_stance_name == "upright" or current_stance_name == "alert") and crouch_enabled:
			set_stance("crouch")
		elif current_stance_name == "crouch" and prone_enabled:
			switch_combat_mode(false)
			set_stance("prone")

func _physics_process(delta):
	# if moving, emit the direction of movement
	if is_movement_ongoing():
		changed_movement_direction.emit(movement_direction)

	#double jump mechanics
	#set the jump count to 0 whenever the player is on the floor
	if main_node.is_on_floor():
		air_jump_counter = 0
	elif air_jump_counter == 0:
		air_jump_counter = 1
	#did the player fall off a ledge without jumping? count that as one jump
	elif air_jump_counter == 0:
		air_jump_counter = 1

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0

func set_movement_state(state : String):
	var stance = get_node(stances[current_stance_name])
	current_movement_state_name = state
	changed_movement_state.emit(stance.get_movement_state(state))

func set_stance(_stance_name : String):
	var next_stance_name : String
	
	next_stance_name = _stance_name
	
	if is_stance_blocked(next_stance_name):
		return
		
	var current_stance = get_node(stances[current_stance_name])
	current_stance.collider.disabled = true
	
	current_stance_name = next_stance_name
	current_stance = get_node(stances[current_stance_name])
	current_stance.collider.disabled = false
	
	changed_stance.emit(current_stance)
	set_movement_state(current_movement_state_name)

func is_stance_blocked(_stance_name : String) -> bool:
	var stance = get_node(stances[_stance_name])
	return stance.is_blocked()

func halt():
	movement_direction.x = 0
	movement_direction.z = 0
	if alert == true:
		set_stance("alert")
	else: 
		set_stance("upright")
	set_movement_state("stand")
	strafing_toggle.emit(false)
	changed_movement_direction.emit(movement_direction)

func continue_movement():
	if not movement_enabled:
		return
	if Input.is_action_pressed("character movement"):
		movement_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		movement_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		changed_movement_direction.emit(movement_direction)
		
		if is_movement_ongoing():
			if Input.is_action_pressed("run") and run_enabled and is_strafing == false:
				set_movement_state("run")
			else:
				set_movement_state("walk")
		else:
			set_movement_state("stand")
		
		#toggle strafing movement and aim weapon
	if (current_stance_name !="prone") and main_node.is_on_floor():
	
		if Input.is_action_pressed("aim") and can_aim():
			strafing_toggle.emit(true)
			set_stance("strafing")
			set_tool_state("aim")
			is_strafing = true

func can_aim():
	if aim_enabled == false:
		return false
	if main_node.is_on_floor() == false:
		return false
	if current_movement_state_name == "run":
		return false

	return true

func switch_combat_mode(mode: bool):
	if mode==true:
		combat_mode=true
		combat_mode_toggle.emit(true)
	else:
		combat_mode=false
		combat_mode_toggle.emit(false)

func set_tool_state(_state: String):
	current_tool_state = _state
	changed_tool_state.emit(_state)

func fire_tool_oneshot(_anim: String):
	tool_use.emit(_anim)

func fire_tool_melee():
	tool_melee.emit()

func toggle_alert(toggle: bool):
	if toggle == false:
		alert = false
		if current_stance_name == "alert":
			set_stance("upright")
		
	else:
		alert = true
		if current_stance_name == "upright":
			set_stance("alert")
