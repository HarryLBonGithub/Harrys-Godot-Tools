extends Node3D

signal set_cam_rotation(_cam_rotation : float)

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera = $CamYaw/CamPitch/SpringArm3D/Camera3D

@export var look_enabled = true
@export var yaw_enabled = true
@export var pitch_enabled = true


var yaw : float = 0
var pitch : float = 0

var yaw_sensitivity : float = 0.07
var pitch_sensitivity : float = 0.07

var yaw_acceleration : float = 15
var pitch_acceleration : float = 15

var pitch_max = 75
var pitch_min = -55

var tween : Tween

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #make the mouse invisible

func _input(event):	
	if event is InputEventMouseMotion: #get the mouse motion
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta):
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	if not look_enabled:
		return
	# rotate the appropriate camera node on a value determined by its current location, the amount of mouse motion, and the speed of the change
	if yaw_enabled:
		yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
		
	if pitch_enabled:
		pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x,pitch, pitch_acceleration * delta)
	
	set_cam_rotation.emit(yaw_node.rotation.y)

func _on_movement_inputs_set_movement_state(_movement_state : MovementState):
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(camera, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
