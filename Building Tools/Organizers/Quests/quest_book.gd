extends Node
class_name QuestBook

var quests:Array[Quest] = []

func addQuest(quest:Quest):
	quests.append(quest)

func removeQuest(quest:Quest):
	quest.erase(quest) #erase moves the first occurance of an item. otherwise does nothing

func getQuests():
	return quests
