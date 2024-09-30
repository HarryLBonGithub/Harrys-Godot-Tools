extends Node

@export var main_node : CharacterBody3D
@export var mesh_root : Node3D
@export var rotation_speed : float = 8

var direction : Vector3
var velocity : Vector3
var acceleration : float
var speed : float
var cam_rotation : float = 0 

func _physics_process(delta):
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	main_node.velocity = main_node.velocity.lerp(velocity,acceleration * delta)
	main_node.move_and_slide()
	
	var target_rotation = atan2(direction.x, direction.z) - main_node.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)

func _on_movement_inputs_set_movement_state(_movement_state):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration

func _on_movement_inputs_set_movement_direction(_movement_direction):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)

func _on_cam_root_set_cam_rotation(_cam_rotation):
	cam_rotation = _cam_rotation
