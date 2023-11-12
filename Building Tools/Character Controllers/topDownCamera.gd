extends Camera3D

@export var target : Node

func _process(delta):
	look_at(target.global_position)
