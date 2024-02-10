extends Node

@onready var myBoard = $"../QuestBoard"
func _on_health_ko():
	$"..".queue_free()


func _on_interaction_interacted(user):
	
	if not user.has_node("QuestBook"):
		return
	var book = user.find_child("QuestBook")
	
	var quests = myBoard.getQuests()
	
	if len(quests) <= 0:
		print("no quests here")
		return
	
	if quests[0] in book.getQuests():
		if user.has_node("MessageCatcher"):
			var catcher = user.find_child("MessageCatcher")
			for q in book.getQuests():
				if q.questName == quests[0].questName and q.completed == true:
					catcher.catchMessage($"../MessageCarrier".messageChains[2])
					return
			
			
			catcher.catchMessage($"../MessageCarrier".messageChains[1])
		print("you already have this")
		return
	#
	myBoard.giveQuest(book, quests[0])
	if user.has_node("MessageCatcher"):
		var catcher = user.find_child("MessageCatcher")
		catcher.catchMessage($"../MessageCarrier".messageChains[0])
	print("quest added")
