extends RayCast3D

#looks for a CursorHint node on a colliding area or body, then provides that node's
#"text property as a message

@export var info : Label

func _ready():
	pass

func _process(delta):
	if not enabled:
		return
	self.force_raycast_update()
	
	if self.is_colliding():
		var area = self.get_collider()
		
		if area.has_node("CursorHint"):
			var hintText = area.find_child("CursorHint").hint
			info.text = hintText
		else:
			info.text = ""
	else:
		info.text = ""
