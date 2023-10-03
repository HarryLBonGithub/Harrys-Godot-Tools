extends Node

@export var targettingRay : RayCast3D
@export var adjustedNode : Node

var originalRotation

func _ready():
	if adjustedNode:
		originalRotation = adjustedNode.rotation

func _process(delta):
	
	if not targettingRay:
		return
	
	targettingRay.force_raycast_update()
	
	if targettingRay.is_colliding():
		var targetPoint = targettingRay.get_collision_point()
		adjustedNode.look_at(targetPoint, Vector3.UP)
	else:
		adjustedNode.rotation = originalRotation
		
	
