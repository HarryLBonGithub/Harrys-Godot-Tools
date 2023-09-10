extends Area3D

@export var damage = 10



func _on_area_entered(area):
	if area.has_node("Health"):
		var target = area.find_child("Health")
		target.take_damage(damage)



func _on_body_entered(body):
	if body.has_node("Health"):
		var target = body.find_child("Health")
		target.take_damage(damage)
