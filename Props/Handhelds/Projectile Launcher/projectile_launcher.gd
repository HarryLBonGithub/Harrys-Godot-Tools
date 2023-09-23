extends Node3D

@export var projectile : PackedScene
@export var maxAmmo = 10
@export var currentAmmo = 10

@onready var room = get_tree().current_scene
@onready var barrelNode = $Barrel

var active = true

func _process(delta):
	
	if Input.is_action_just_pressed("use_tool"):	
		if maxAmmo > 0 and currentAmmo <=0:
			dryFire()
		else:
			var proj = projectile.instantiate()
			proj.transform = barrelNode.global_transform
			room.add_child(proj)
			
			currentAmmo -= 1

func dryFire():
	pass
