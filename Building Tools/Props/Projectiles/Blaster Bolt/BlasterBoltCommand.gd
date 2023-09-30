extends Node


func _on_damage_box_area_entered(area):
	
	if area == $"..":
		return
	
	$"..".queue_free()



func _on_damage_box_body_entered(body):
	if body == $"..":
		return
	$"..".queue_free()
