extends Node

var targetQuest = "Dummy's Quest"

func interact(user):
	
	if not user.has_node("QuestBook"):
		return
	
	var book = user.find_child("QuestBook")
	var quests = book.get_children()
	
	for q in quests:
		if q.questName == targetQuest:
			q.completed = true
			book.untrack(q)
