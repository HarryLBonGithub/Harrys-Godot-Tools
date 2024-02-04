extends Node

var managerNode

@onready var room = get_tree().current_scene

@onready var questBookNode = $"../QuestBook"

func _on_health_ko():
	$"..".queue_free()

func _ready():
	if room.has_node("QuestManager"):
			managerNode = room.find_child("QuestManager")
