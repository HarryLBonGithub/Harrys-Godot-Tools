extends Node
class_name QuestBook

@export var questBookOwner : Node

@export var quests:Array[Quest] = []

@export var simpleTracker : Node


func _ready():
	connectToQuestManager()
	for myQuest in quests:
		print(myQuest.questName)
	
func addQuest(quest:Quest):
	quests.append(quest)
	if simpleTracker:
		simpleTracker.track(quest)

func removeQuest(quest:Quest):
	quest.erase(quest) #erase moves the first occurance of an item. otherwise does nothing

func giveQuest(book:QuestBook, quest:Quest):
	book.addQuest(quest)

func getQuests():
	return quests

func progressQuest(quester, quest):
	
	print(questBookOwner.name + ": Quest Progress Check---------------------------")
	
	if quester != questBookOwner:
		print("Global signal emitted. Not for you " + questBookOwner.name)
		return
	
	for myQuest in quests:
		print("is " + myQuest.questName + " the same as "+ quest.questName)
		if myQuest.questName == quest.questName:
			myQuest.progressCount +=1
			print(myQuest.questName + " Progress: " + str(myQuest.progressCount) + "/" + str(myQuest.progressTarget))
			completionCheck(myQuest)

func completionCheck(quest:Quest):
	if quest.progressCount >= quest.progressTarget:
		quest.completed = true
		print("You finished " + quest.questName)

func connectToQuestManager():
	QuestManager.progressQuest.connect(progressQuest)
