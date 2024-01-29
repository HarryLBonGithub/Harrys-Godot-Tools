extends Node

signal new_quest

@export var questUI = Node

func track(quest:Quest):
	if not questUI:
		print("no ui")
		return
	print("creating label")
	var newQuestLabel = Label.new()
	newQuestLabel.text = quest.summary
	questUI.containerNode.add_child(newQuestLabel)
	quest.active = true

func untrack(quest:Quest):
	if not questUI:
		return
	var labelChildren = questUI.containerNode.get_children()
	
	for labels in labelChildren:
		if labels.text == quest.summary:
			labels.queue_free()
	quest.active = false
