extends CharacterBody3D

#mouse setting variables
@export var mouseSensitivity = 0.3
@export var headTurnMaxSitting = 90

#movement variables
@export var flightSpeed = 10
@export var boostSpeed = 20
@export var crawlSpeed = 5
@export var acceleration = 2
@export var deceleration = 6
@export var rollSpeed = 1.0
@export var rollAcceleration = 3.0
@export var rollDeceleration = 6.0

#movement toggles
@export var movementEnabled = true
@export var forwardEnabled = true
@export var backEnabled = true
@export var leftEnabled = true
@export var rightEnabled = true
@export var upEnabled = true
@export var downEnabled = true
@export var lookEnabled = true
@export var lookUpDownEnabled = true
@export var rollEnabled = true


#running variables
var cameraMotion = Vector2()
var cameraPitch = 0 #camera vertical angle
var cameraYaw = 0 #camera horizontal angle
var angular_velocity:Quaternion
var rollAmmount = 0
var rollTargetSpeed = 0

var playerVelocity = Vector3()

#node variables
@onready var headNode = $Head

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		cameraMotion = event.relative
		cameraPitch = fmod(cameraPitch - event.relative.y, 360)
		cameraYaw = fmod(cameraYaw - event.relative.x, 360)

func _physics_process(delta):
	fly(delta)
	roll(delta)
	look(delta)

func aim():
	
	if not lookEnabled:
		return
	
	if cameraMotion.length() > 0: #if the camera has moved
		rotate_y(deg_to_rad(-cameraMotion.x * mouseSensitivity)) #turn the whole body left/right
		headNode.rotate_x(deg_to_rad(-cameraMotion.y * mouseSensitivity)) #turn the 'head' up/down

	cameraMotion = Vector2()

func fly(delta):
	var motion = Vector3()
	
	if not movementEnabled:
		return
		
	if Input.is_action_pressed("move_forward") and forwardEnabled:
		motion -= headNode.global_transform.basis.z
	if Input.is_action_pressed("move_backward") and backEnabled:
		motion += headNode.global_transform.basis.z
	if Input.is_action_pressed("move_left") and leftEnabled:
		motion -= headNode.global_transform.basis.x
	if Input.is_action_pressed("move_right") and rightEnabled:
		motion += headNode.global_transform.basis.x
	if Input.is_action_pressed("jump") and upEnabled:
		motion += headNode.global_transform.basis.y
	if Input.is_action_pressed("crouch") and downEnabled:
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
	var accelDecel = rollAcceleration
	if Input.is_action_pressed("roll_left"):
		rollTargetSpeed = abs(rollSpeed)
	elif  Input.is_action_pressed("roll_right"):
		rollTargetSpeed = abs(rollSpeed) * -1
	else:
		rollTargetSpeed = 0
		accelDecel = rollDeceleration
		
	rollAmmount = lerp(float(rollAmmount),float(rollTargetSpeed), accelDecel * delta)
	transform.basis = transform.basis.rotated(transform.basis.z, rollAmmount * delta)

func look(delta):
	if !lookEnabled:
		return

	transform.basis = transform.basis.rotated(-transform.basis.x, cameraMotion.y * mouseSensitivity * delta)
	transform.basis = transform.basis.rotated(-transform.basis.y, cameraMotion.x * mouseSensitivity * delta)
	
	transform.basis = transform.basis.orthonormalized()
	cameraMotion = Vector2()
