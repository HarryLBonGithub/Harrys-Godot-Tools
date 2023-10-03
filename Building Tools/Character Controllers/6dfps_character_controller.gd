extends CharacterBody3D

#mouse setting variables
@export var mouseSensitivity = 0.3
@export var headTiltMax = 90
@export var headTurnMaxSitting = 90

#movement variables
@export var flightSpeed = 10
@export var boostSpeed = 20
@export var crawlSpeed = 5
@export var acceleration = 2
@export var deceleration = 6
@export var rollSpeed = 0.1

#movement toggles
@export var movementEnabled = true
@export var lookEnabled = true
@export var lookUpDownEnabled = true
@export var rollEnabled = true

#running variables
var cameraMotion = Vector2()
var cameraAngleV = 0 #camera vertical angle
var cameraAngleH = 0 #camera horizontal angle

var playerVelocity = Vector3()

#node variables
@onready var headNode = $Roller/Head
@onready var rollerNode = $Roller

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	aim()
	fly(delta)
	roll(delta)

func _input(event):
	if event is InputEventMouseMotion:
		cameraMotion = event.relative #stores the mouses movement

func aim():
	
	if not lookEnabled:
		return
	
	if cameraMotion.length() > 0: #if the camera has moved
		rotate_y(deg_to_rad(-cameraMotion.x * mouseSensitivity)) #turn the whole body left/right
		headNode.rotate_x(deg_to_rad(-cameraMotion.y * mouseSensitivity)) #turn the whole body up/down

	cameraMotion = Vector2()

func fly(delta):
	var motion = Vector3()
	
	if not movementEnabled:
		return
		
	if Input.is_action_pressed("move_forward"):
		motion -= headNode.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		motion += headNode.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		motion -= headNode.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		motion += headNode.global_transform.basis.x
	if Input.is_action_pressed("jump"):
		motion += headNode.global_transform.basis.y
	if Input.is_action_pressed("crouch"):
		motion -= headNode.global_transform.basis.y
	motion = motion.normalized()
	
	
	#set how fast the player will move
	var speed
	if Input.is_action_pressed("crouch"):
		speed = crawlSpeed
	elif Input.is_action_pressed("run"):
		speed = boostSpeed
	else: 
		speed = flightSpeed
	
	var targetSpeed = motion * speed
	
	var speedChange
	
	if motion.dot(playerVelocity) > 0:
		speedChange = acceleration
	else:
		speedChange = deceleration
		
	playerVelocity = playerVelocity.lerp(targetSpeed, speedChange * delta)
	
	velocity = playerVelocity
	
	move_and_slide()

func roll(delta):
	if !rollEnabled:
		return
	
	if Input.is_action_pressed("roll_left"):
		rollerNode.rotate_z(deg_to_rad(rollSpeed))
	
	if Input.is_action_pressed("roll_right"):
		rollerNode.rotate_z(deg_to_rad(-rollSpeed))
