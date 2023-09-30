extends Node3D

class_name ActionTool

@export var projectile : PackedScene

@export var active = true

@onready var room = get_tree().current_scene


func use():
	var proj = projectile.instantiate()
	proj.transform = self.global_transform
	room.add_child(proj)
	
	
