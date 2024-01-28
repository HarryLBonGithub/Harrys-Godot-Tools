extends Node

@onready var parent = get_parent()

func interact(user):
	print("Dummy interacted")
	
	if user.has_node("QuestBook"):
		
		if parent.has_node("DummyQuest") == false:
			return
		
		var usersBook = user.find_child("QuestBook")	
		
		$"../DummyQuest".activeToggle()
		$"../DummyQuest".giveTo(usersBook)
		
		print("quest given")
		usersBook.emit_signal("new_quest")
