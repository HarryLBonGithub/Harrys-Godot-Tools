extends Node3D

enum StateEnum {OPEN,CLOSED,LOCKED,BROKEN}

@export var state: StateEnum

@export var openMessage = "Press [E] to close"
@export var closedMessage = "Press [E] to open"
@export var lockedMessage = "Locked"
@export var brokenMessage = "Broken"
@export var keyID = ""

@onready var doorBodyNode = $DoorBody
@onready var animationsNode = $DoorAnimations
@onready var hintNode = $DoorBody/CursorHint

@onready var openSoundNode = $DoorAudio/OpenSound
@onready var closeSoundNode = $DoorAudio/CloseSound
@onready var lockedSoundNode = $DoorAudio/LockedSound
@onready var brokenSoundNode = $DoorAudio/BrokenSound

func _process(delta):
	match state:
		3: #broken
			hintNode.hint = brokenMessage
		2: #locked
			hintNode.hint = lockedMessage
		1: #closed
			hintNode.hint = closedMessage
		0: #open
			hintNode.hint = openMessage

func _on_interaction_interacted():
	
	match state:
		3: #broken
			brokenSoundNode.play()
		2: #locked
			lockedSoundNode.play()
		1: #closed
			state = 0
			animationsNode.play("open")
			openSoundNode.play()
		0: #open
			state = 1
			animationsNode.play("close")
			closeSoundNode.play()


func _on_exit_detector_body_exited(body):
	if body == doorBodyNode:
		return
	
	match state:
		0: #open
			state = 1
			animationsNode.play("close")
			closeSoundNode.play()
