extends Node

@onready var parent = get_parent()

func interact():
	parent.queue_free()
