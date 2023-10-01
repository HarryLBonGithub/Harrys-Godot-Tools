extends Node

@export var targettingRay : RayCast3D
@export var adjustedNode : Node

func _process(delta):
	
	if not targettingRay:
		return
	
	if Input.is_action_pressed("use_tool"):
		targettingRay.force_raycast_update()
	
		if targettingRay.is_colliding():
			var targetPoint = targettingRay.get_collision_point()
			adjustedNode.look_at(targetPoint, Vector3.UP)
