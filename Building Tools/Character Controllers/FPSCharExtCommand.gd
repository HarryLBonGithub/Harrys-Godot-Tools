extends Node

var managerNode

@onready var room = get_tree().current_scene

@onready var questBookNode = $"../QuestBook"

func _on_health_ko():
	$"..".queue_free()

func _ready():
	if room.has_node("QuestManager"):
			managerNode = room.find_child("QuestManager")


func _on_quest_book_new_quest():
	var quests = questBookNode.get_children()
	for q in quests:
		if q.active == true:
			questBookNode.track(q)
