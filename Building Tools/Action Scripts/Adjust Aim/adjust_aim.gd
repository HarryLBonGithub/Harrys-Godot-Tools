extends Node

@export var targettingRay : RayCast3D
@export var adjustedNode : Node

var originalRotation
var targetLocation : Vector3

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
		targetLocation = targetPoint
	else:
		adjustedNode.rotation = originalRotation
		
	
