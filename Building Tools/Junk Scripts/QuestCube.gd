extends MeshInstance3D

@export var heldQuest:Quest

func _on_interaction_interacted(user):
	QuestManager.progressQuest.emit(user,heldQuest)
