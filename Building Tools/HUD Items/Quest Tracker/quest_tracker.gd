extends Panel

@onready var container = $LabelContainer
@export var questBook : QuestBook

func track(quest:Quest):
	var new_label = Label.new()
	new_label.text = quest.summary
	container.add_child(new_label)

func clear():
	for child in container.get_children():
		child.queue_free()
