extends CharacterBody3D

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

var playerVelocity = Vector3()

@onready var initialYRot
@onready var cameraNode = $CharacterCamera
@onready var fillerMeshNode = $FillerMesh

func _ready():
	initialYRot = fillerMeshNode.global_rotation.y

func _physics_process(delta):
	walk(delta)
	meshFlip()

func walk(delta):
	var motion = Vector3()
	
	if not movementEnabled:
		return
	
	if Input.is_action_pressed("move_forward") and forwardEnabled:
		motion -= cameraNode.global_transform.basis.z
	if Input.is_action_pressed("move_backward") and backEnabled:
		motion += cameraNode.global_transform.basis.z
	if Input.is_action_pressed("move_left") and leftEnabled:
		motion -= cameraNode.global_transform.basis.x
	if Input.is_action_pressed("move_right") and rightEnabled:
		motion += cameraNode.global_transform.basis.x
	
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

func meshFlip():
	if Input.is_action_pressed("move_forward") and forwardEnabled:
		fillerMeshNode.global_rotation.y = initialYRot 
	if Input.is_action_pressed("move_backward") and backEnabled:
		fillerMeshNode.global_rotation.y = initialYRot - deg_to_rad(180)
	if Input.is_action_pressed("move_left") and leftEnabled:
		fillerMeshNode.global_rotation.y = initialYRot + deg_to_rad(90)
	if Input.is_action_pressed("move_right") and rightEnabled:
		fillerMeshNode.global_rotation.y = initialYRot - deg_to_rad(90)
