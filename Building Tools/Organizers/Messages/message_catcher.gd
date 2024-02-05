extends Node

signal newMessage

var currentMessage : MessageChain
var currentStep = 0
var chainLength = 1

func catchMessage(chain:MessageChain):
	currentStep = 0
	currentMessage = chain
	chainLength = len(chain.messagesArray)
	newMessage.emit()

func getMessage():
	return currentMessage
