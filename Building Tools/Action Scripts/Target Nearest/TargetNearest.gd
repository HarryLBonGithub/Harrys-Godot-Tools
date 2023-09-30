extends Node

@export var pointer : Node
@export var targetGroup = ""

var noTargets = false

func target():
	var targets = get_tree().get_nodes_in_group(targetGroup)
	
	if len(targets) <=0:
		noTargets = true
		return
	noTargets = false
	
	var closest = targets[0]
	
	for potentialTarget in targets:
		if potentialTarget.global_position.distance_to(pointer.global_position) < closest.global_position.distance_to(pointer.global_position):
			closest = potentialTarget
	pointer.look_at(closest.global_position, Vector3.UP)

func changeTarget(group):
	targetGroup = group
