extends Node

var managerNode

@onready var room = get_tree().current_scene

@export var mainNode = Node

@onready var questBookNode = $"../QuestBook"

func _on_health_ko():
	$"..".queue_free()

func _ready():
	if room.has_node("QuestManager"):
			managerNode = room.find_child("QuestManager")
			print("manager node Found")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			var keycode = event.as_text_key_label()
			QuestManager.keyPressed.emit(mainNode,keycode)
			print(keycode)
