extends Node
class_name QuestBoard

@export var questBoardOwner : Node

@export var quests:Array[Quest] = []

func giveQuest(book:QuestBook, quest:Quest):
	book.addQuest(quest)

func getQuests():
	return quests

