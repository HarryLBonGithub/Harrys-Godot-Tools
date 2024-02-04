extends Node

signal interacted(user)

@onready var parent = get_parent()

func interact(user):
	print("Dummy interacted")
	interacted.emit(user)
