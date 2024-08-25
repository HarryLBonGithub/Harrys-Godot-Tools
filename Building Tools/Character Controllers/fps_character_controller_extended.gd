extends CharacterBody3D

var state = "standard"

@onready var room = get_tree().current_scene
@onready var questBookNode = $QuestBook
@onready var messageCatcherNode = $MessageCatcher
@onready var messageDisplayNode = $PlayerUI/SimpleMessageDisplay
@onready var mover = $MovementControl
@onready var interacter = $Head/InteractionRay

var messageInputReady = false

func _ready():
	pass

func _process(delta):
	if state == "standard":
		interacter.enabled = true
		pass
	elif state == "message":
		next_message_step()
		messageInputReady = true

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			var keycode = event.as_text_key_label()
			QuestManager.keyPressed.emit(self,keycode)
			print(keycode)

func _on_health_ko():
	queue_free()

func _on_message_catcher_new_message():
	state = "message"
	messageInputReady = false
	mover.movementEnabled = false
	mover.lookEnabled =false
	interacter.enabled = false
	messageDisplayNode.visible = true
	var newMessage = messageCatcherNode.getMessage()
	messageDisplayNode.displayMessage(newMessage.messagesArray[0])
	

func next_message_step():
	if Input.is_action_just_pressed("interact") and messageInputReady:
		messageCatcherNode.currentStep += 1
		if messageCatcherNode.currentStep >= messageCatcherNode.chainLength:
			
			state="standard"
			mover.movementEnabled = true
			mover.lookEnabled = true
			messageDisplayNode.visible = false
			return
		
		var newMessage = messageCatcherNode.getMessage()
		messageDisplayNode.displayMessage(newMessage.messagesArray[messageCatcherNode.currentStep])
