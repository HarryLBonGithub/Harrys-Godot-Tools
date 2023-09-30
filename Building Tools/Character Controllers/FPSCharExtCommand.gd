extends Node


func _on_health_ko():
	$"..".queue_free()
