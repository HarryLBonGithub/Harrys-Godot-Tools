extends Control

signal audioFinished

@onready var portraitNode = %MessengerPortrait
@onready var nameNode = %MessengerName
@onready var messageNode = %MessageLabel
@onready var continueLabel = $VBoxContainer/ContinueContainer/ToContinueLabel

@onready var audioNode = $AudioMessage

func _ready():
	
	var eventList = InputMap.action_get_events("interact")
	var inputCharacter = ""
	
	for e in eventList:
		inputCharacter = e.as_text()[0]
	
	continueLabel.text = "Press [" + inputCharacter + "] to continue"

func displayMessage(message:Message):
	if message.image:
		portraitNode.texture = message.image
	
	if message.messenger:
		nameNode.text = message.messenger
	
	if message.text:
		messageNode.text = message.text
	
	if message.audio:
		audioNode.stream = message.audio
		audioNode.play()


func _on_audio_message_finished():
	audioFinished.emit()
