extends Node3D

@export var toolName = "Launcher"

@export var projectile : PackedScene
@export var maxAmmo = 10
@export var currentAmmo = 10

@export var ammoUI : AmmoTracker

@export var active = true

@onready var room = get_tree().current_scene
@onready var barrelNode = $Barrel



func _ready():
	
	if !active:
		return
	
	if ammoUI:
		ammoUI.toolName.text = str(toolName)
		ammoUI.max.text = str(maxAmmo)
		ammoUI.current.text = str(currentAmmo)

func _process(delta):
	
	if !active:
		return
	
	if Input.is_action_just_pressed("use_tool"):	
		if maxAmmo > 0 and currentAmmo <=0:
			dryFire()
		else:
			var proj = projectile.instantiate()
			proj.transform = barrelNode.global_transform
			room.add_child(proj)
			
			if maxAmmo <= 0:
				return
				
			currentAmmo -= 1
			
			if ammoUI:
				ammoUI.current.text = str(currentAmmo)

func dryFire():
	pass
