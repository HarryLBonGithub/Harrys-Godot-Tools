extends Node

@onready var myBoard = $"../QuestBoard"
func _on_health_ko():
	$"..".queue_free()


func _on_interaction_interacted(user):
	pass
	if not user.has_node("QuestBook"):
		return
	var book = user.find_child("QuestBook")
	
	var quests = myBoard.getQuests()
	
	if len(quests) <= 0:
		print("no quests here")
		return
	
	if quests[0] in book.getQuests():
		print("you already have this")
		return
	#
	myBoard.giveQuest(book, quests[0])
	print("quest added")
