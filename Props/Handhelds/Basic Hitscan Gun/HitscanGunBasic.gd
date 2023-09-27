extends RayCast3D


@export var damage = 10

@onready var bangNode = $bang

var active = true


func _process(delta):
	
	if Input.is_action_just_pressed("use_tool") and active:
		
		bangNode.play()
		
		if not enabled:
			return
		
		self.force_raycast_update()
		
		if self.is_colliding() == false:
			return
			
		var body = self.get_collider()
			
		if body.has_node("Health"):
			var target = body.find_child("Health")
			target.take_damage(damage)
