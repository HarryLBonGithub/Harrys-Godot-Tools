extends Node

@onready var parent = get_parent()

func interact(user):
	parent.queue_free()
