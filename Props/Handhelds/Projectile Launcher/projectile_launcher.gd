extends Node3D

@export var toolName = "Launcher"

@export var projectile : PackedScene
@export var ammoNode : Ammo
@export var ammoUI : AmmoTracker

@export var active = true

@onready var room = get_tree().current_scene
@onready var barrelNode = $Barrel

func _ready():
	
	if !active:
		return
	
	if ammoUI:
		ammoUI.toolName.text = str(toolName)
		if ammoNode:
			ammoUI.max.text = str(ammoNode.maxAmmo)
			ammoUI.current.text = str(ammoNode.currentAmmo)

func _process(delta):
	
	if !active:
		return
	
	if Input.is_action_just_pressed("use_tool"):	
		if ammoNode and ammoNode.currentAmmo <=0:
			dryFire()
		else:
			var proj = projectile.instantiate()
			proj.transform = barrelNode.global_transform
			room.add_child(proj)
			
			if !ammoNode:
				return
			ammoNode.currentAmmo -= 1
			
			if !ammoUI:
				return
			ammoUI.current.text = str(ammoNode.currentAmmo)

func dryFire():
	pass
