extends Area3D
@export var healing = 10

signal healthDelivered

func _on_area_entered(area):
	if area.has_node("Health"):
		var target = area.find_child("Health")
		
		if target.currentHealth < target.maxHealth:
			target.heal_damage(healing)
			emit_signal("healthDelivered")


func _on_body_entered(body):
	if body.has_node("Health"):
		var target = body.find_child("Health")
		
		if target.currentHealth < target.maxHealth:
			target.heal_damage(healing)
			emit_signal("healthDelivered")
