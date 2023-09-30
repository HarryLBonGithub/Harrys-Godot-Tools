extends "res://Building Tools/Props/Projectiles/projectile.gd"



func _on_damage_box_area_entered(area):
	queue_free()


func _on_damage_box_body_entered(body):
	queue_free()
