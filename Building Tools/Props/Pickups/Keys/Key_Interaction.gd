extends Node

@onready var mainNode = $".."

func interact(user):
	
	if user.has_node("KeyRing") == false:
		return
	
	var users_keys = user.find_child("KeyRing")
	
	if mainNode.key_ID == "":
		users_keys.generic_keys += 1
		mainNode.queue_free()
		return
	else:
		users_keys.named_keys.append(mainNode.key_ID)
		mainNode.queue_free()
		return
