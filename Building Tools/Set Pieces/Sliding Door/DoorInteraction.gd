extends Node

signal interacted

var lastUser : Node

func interact(user):
	lastUser = user
	emit_signal("interacted")
	
