extends Node

@onready var targettingNode = $"../TargetNearest"
@onready var launcher = $"../Gun/ProjectileLauncher"

func _process(delta):
	targettingNode.target()
	
	if targettingNode.noTargets:
		$"../Timer".stop()


func _on_timer_timeout():
	launcher.use()
