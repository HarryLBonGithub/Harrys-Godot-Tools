extends Node3D

@export var projectile : PackedScene
@export var maxAmmo = 10
@export var currentAmmo = 10

@export var maxAmmoUI:Label
@export var currentAmmoUI: Label

@export var active = true

@onready var room = get_tree().current_scene
@onready var barrelNode = $Barrel



func _ready():
	
	if !active:
		return
	
	if maxAmmoUI and currentAmmoUI:
		maxAmmoUI.text = str(maxAmmo)
		currentAmmoUI.text = str(currentAmmo)

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
			
			if maxAmmoUI and currentAmmoUI:
				currentAmmoUI.text = str(currentAmmo)

func dryFire():
	pass
