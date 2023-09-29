extends Node3D

@export var toolName = "Launcher"

@export var projectile : PackedScene
@export var ammoNode : Ammo
@export var ammoUI : AmmoTracker
@export var fireRate : Timer

@export var active = true

@onready var room = get_tree().current_scene
@onready var barrelNode = $Barrel

var readyToFire = true

func _ready():
	
	if !active:
		return
	
	if ammoUI:
		ammoUI.toolName.text = str(toolName)
		if ammoNode:
			ammoUI.max.text = str(ammoNode.maxAmmo)
			ammoUI.current.text = str(ammoNode.currentAmmo)

func _process(delta):
	fire()
	ready()
	

func dryFire():
	pass

func fire():
	if !active or !readyToFire:
		return

	
	if Input.is_action_pressed("use_tool"):	
		if ammoNode and ammoNode.currentAmmo <=0:
			dryFire()
		else:
			var proj = projectile.instantiate()
			proj.transform = barrelNode.global_transform
			room.add_child(proj)
			readyToFire = false
			
			if fireRate:
				fireRate.start()
			
			if !ammoNode:
				return
			ammoNode.currentAmmo -= 1
			
			if !ammoUI:
				return
			ammoUI.current.text = str(ammoNode.currentAmmo)

func ready():
	if Input.is_action_just_released("use_tool"):
		readyToFire = true
	
	if !fireRate:
		return
	
	if fireRate.is_stopped():
		readyToFire = true
	
	
