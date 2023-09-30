extends Node


func _on_healing_box_health_delivered():
	
	$"..".queue_free()
