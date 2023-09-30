extends Area3D

signal damageDelivered

@export var damage = 10
@export var ignore : Node


func _on_area_entered(area):
	
	if area.has_node("Health"):
		var target = area.find_child("Health")
		target.take_damage(damage)
		emit_signal("damageDelivered")



func _on_body_entered(body):

	if body.has_node("Health"):
		var target = body.find_child("Health")
		target.take_damage(damage)
		emit_signal("damageDelivered")
