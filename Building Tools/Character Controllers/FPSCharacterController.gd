extends CharacterBody3D

#mouse setting variables
@export var mouseSensitivity = 0.3
@export var headTiltMax = 90
@export var headTurnMaxSitting = 90

#movement variables
@export var walkingSpeed = 10
@export var runningSpeed = 20
@export var crouchingSpeed = 5
@export var adjustHeightSpeed = 5 #used in crouching. set to 0 to disable crouch
@export var acceleration = 2
@export var deceleration = 6

@export var jumpHeight = 5
@export var gravityInput = 9.8 * 1
@onready var gravityActual = gravityInput * -1

@export var floorCheck = false

#movement toggles
@export var movementEnabled = true
@export var forwardEnabled = true
@export var backEnabled = true
@export var leftEnabled = true
@export var rightEnabled = true
@export var lookEnabled = true
@export var lookUpDownEnabled = true
@export var jumpEnabled = true

#editor toggles
@export var meshOn = true


#running variables
var cameraMotion = Vector2()
var cameraAngleV = 0 #camera vertical angle
var cameraAngleH = 0 #camera horizontal angle

var playerVelocity = Vector3()

#node variables
@onready var cameraNode = $Head/PlayerCamera
@onready var floorCheckNode = $FloorCheck
@onready var headNode = $Head



func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if not floorCheck:
		floorCheckNode.enabled = false
	else:
		floorCheckNode.enabled = true
	
func _physics_process(delta):
	aim()
	walk(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		cameraMotion = event.relative #stores the mouses movement

func aim():
	
	if not lookEnabled:
		return
	
	if cameraMotion.length() > 0: #if the camera has moved
		rotate_y(deg_to_rad(-cameraMotion.x * mouseSensitivity)) #turn the whole body left/right
		
		if lookUpDownEnabled:
			var change = -cameraMotion.y * mouseSensitivity #stores the ammount of potential change
			if change + cameraAngleH < headTiltMax and change + cameraAngleH > -headTiltMax: #check tilt does not exceed maximum
				headNode.rotate_x((deg_to_rad(change))) #turn head
				cameraAngleH += change #track the angle for tilt check

	cameraMotion = Vector2()

func walk(delta): #needs more documentation
	var motion = Vector3()
	
	if not movementEnabled:
		return

	if Input.is_action_pressed("move_forward") and forwardEnabled:
		motion -= global_transform.basis.z
	if Input.is_action_pressed("move_backward") and backEnabled:
		motion += global_transform.basis.z
	if Input.is_action_pressed("move_left") and leftEnabled:
		motion -= global_transform.basis.x
	if Input.is_action_pressed("move_right") and rightEnabled:
		motion += global_transform.basis.x
	
	motion = motion.normalized()
	
	#player falls if not on the floor
	if not is_on_floor(): 
		playerVelocity.y += gravityActual * delta
	
	#creates a temporary velocity that has no 'up/down'
	var tempVelocity = playerVelocity
	tempVelocity.y = 0
	
	#set how fast the player will move
	var speed
	if Input.is_action_pressed("crouch"):
		speed = crouchingSpeed
	elif Input.is_action_pressed("run"):
		speed = runningSpeed
	else: 
		speed = walkingSpeed
	
	var targetSpeed = motion * speed
	
	var speedChange
	
	if motion.dot(tempVelocity) > 0:
		speedChange = acceleration
	else:
		speedChange = deceleration
	
	tempVelocity = tempVelocity.lerp(targetSpeed, speedChange * delta)
	playerVelocity.x = tempVelocity.x
	playerVelocity.z = tempVelocity.z
	
	if jumpEnabled:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			playerVelocity.y = jumpHeight
	
	velocity = playerVelocity
	
	move_and_slide()
