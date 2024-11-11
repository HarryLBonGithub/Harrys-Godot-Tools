extends Node

@export var main_node : CharacterBody3D
@export var mesh_root : Node3D
@export var rotation_speed : float = 8
@export var fall_gravity = 45


@onready var aiming_IK = $"../MeshRoot/Lowpoly Cartoon Humans_V4/Humanoid_Armature/Skeleton3D/aim_IK"

var jump_gravity : float = fall_gravity
var direction : Vector3
var velocity : Vector3
var acceleration : float
var speed : float
var cam_rotation : float = 0 
var strafing = false
var direction_changed = false

func _physics_process(delta):
	#"normalize" the movement velocity so that diagonal movement is the same speed as cardinal movement
	#based on the stored direction below
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	#set fall gravity based on whether or not the fall follows a jump
	if not main_node.is_on_floor():
		if velocity.y >=0:
			velocity.y -=jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
	#move the character based on the normalized velocity value
	main_node.velocity = main_node.velocity.lerp(velocity,acceleration * delta)
	main_node.move_and_slide()
	
	#if the character is aiming, look in the same direction as the camera
	#otherwise if the character has gotten some directional input, fase the direction of movement
	if strafing:
		var target_rotation = cam_rotation
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
		aiming_IK.interpolation = lerpf(aiming_IK.interpolation,1, 0.1)
		# mesh_root.rotation.y = target_rotation
	elif direction_changed:
		var target_rotation = atan2(direction.x, direction.z) - main_node.rotation.y
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation - 179, rotation_speed * delta)
	
	direction_changed = false
	
func _on_cam_root_set_cam_rotation(_cam_rotation):
	#when the camera moves, store that value
	cam_rotation = _cam_rotation

func _on_movement_inputs_pressed_jump(jump_state):
	#calculate the jump speed basedon a passed 'jump state'
	velocity.y = 2 * jump_state.jump_height / jump_state.apex_duration
	jump_gravity = velocity.y / jump_state.apex_duration

func _on_movement_inputs_changed_movement_state(_movement_state):
	#when a new movement state is set, adjust the speed and acceleration
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration

func _on_movement_inputs_changed_movement_direction(_movement_direction):
	#when a new movement direction is set, store a rotated version based on the camera's rotation
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)
	direction_changed = true

func _on_movement_inputs_strafing_toggle(_strafing):
	strafing = _strafing
	
	aiming_IK.interpolation = 0
	
	if strafing == true:
		aiming_IK.start()
	else:
		aiming_IK.stop()
