extends RayCast3D


func _process(delta):

	if Input.is_action_just_pressed("interact"):
		
		if not enabled:
			return
		
		self.force_raycast_update()
		
		if self.is_colliding() == false:
			return
			
		var body = self.get_collider()
			
		if body.has_node("Interaction"):
			var target = body.find_child("Interaction")
			target.interact();
