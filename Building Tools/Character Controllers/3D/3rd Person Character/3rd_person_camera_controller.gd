extends Node3D

signal set_cam_rotation(_cam_rotation : float)

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera = $CamYaw/CamPitch/SpringArm3D/Camera3D
@onready var spring_arm = $CamYaw/CamPitch/SpringArm3D
@onready var main_node = $".."

@export var look_enabled = true
@export var yaw_enabled = true
@export var pitch_enabled = true
@export var invert_pitch = false

var yaw : float = 0
var pitch : float = 0

var yaw_sensitivity : float = 0.07
var pitch_sensitivity : float = 0.07

var yaw_acceleration : float = 15
var pitch_acceleration : float = 15

var pitch_max = 75
var pitch_min = -55

var tween : Tween

var position_offset : Vector3 = Vector3(0,1.7,0)
var position_offset_target : Vector3 = Vector3(0,1.7,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #make the mouse invisible
	spring_arm.add_excluded_object(main_node.get_rid())
	top_level = true
	

func _input(event):	
	if event is InputEventMouseMotion: #get the mouse motion
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta):
	
	position_offset = lerp(position_offset,position_offset_target,  4 * delta)
	global_position = lerp(global_position, main_node.global_position + position_offset, 18 * delta)
	
	#set prevent the camera from flipping over or under the player
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	if not look_enabled:
		return
	# rotate the appropriate camera node on a value determined by its current location, the amount of mouse motion, and the speed of the change
	if yaw_enabled:
		yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
		
	if pitch_enabled:
		if invert_pitch:
			pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x,pitch * -1, pitch_acceleration * delta)
		else:
			pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x,pitch, pitch_acceleration * delta)
	
	set_cam_rotation.emit(yaw_node.rotation.y)

func _on_movement_inputs_changed_movement_state(_movement_state):
	if tween:
		tween.kill()
		
	tween = create_tween()
	#set the camera's field of view based on the current movment state
	tween.tween_property(camera, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_movement_inputs_changed_stance(stance):
	position_offset_target.y = stance.camera_height
