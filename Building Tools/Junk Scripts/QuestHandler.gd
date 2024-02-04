extends Node

@onready var player = $"../FPSCharacterControllerExt"
@export var givenQuest : Quest



func _on_interaction_interacted(user):
	if user.has_node("QuestBook"):
		var book = user.find_child("QuestBook")
		book.addQuest(givenQuest)
