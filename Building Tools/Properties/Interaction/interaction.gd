extends Node

signal interacted(user)

func interact(user):
	interacted.emit(user)
