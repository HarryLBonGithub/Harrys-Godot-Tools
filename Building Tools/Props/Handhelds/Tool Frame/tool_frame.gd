extends Node3D

@export var toolName = "Tool Frame"

@export var actionTool : ActionTool
@export var ammoNode : Ammo
@export var ammoUI : AmmoTracker
@export var fireRate : Timer
@export var useSound : AudioStreamPlayer3D
@export var emptySound : AudioStreamPlayer3D
@export var reloadSound : AudioStreamPlayer3D
@export var aimRay : RayCast3D

@export var active = true

var readyToFire = true

func _ready():
	if aimRay:
		if has_node("AdjustAim"):
			var aimNode = find_child("AdjustAim")
			aimNode.targettingRay = aimRay
	
	if not active:
		return
	
	if ammoUI:
		ammoUI.toolName.text = str(toolName)
		if ammoNode:
			ammoUI.max.text = str(ammoNode.maxAmmo)
			ammoUI.current.text = str(ammoNode.currentAmmo)

func _process(delta):
	if not actionTool or not active:
		return
	useTool()
	dryFire()
	readyTool()
	
func useTool():
	if Input.is_action_pressed("use_tool"):
		
		if not readyToFire:
			return
		
		if ammoNode:
			if ammoNode.currentAmmo <=0:
				readyToFire = false
				return
			else:
				ammoNode.currentAmmo -= 1
				
		actionTool.use()
		readyToFire = false
		
		if useSound:
			useSound.play()
		
		if fireRate:
			fireRate.one_shot = true
			fireRate.start()
			
func readyTool():
	if Input.is_action_just_released("use_tool"):
		readyToFire = true
	
	if !fireRate:
		return
	
	if fireRate.is_stopped():
		readyToFire = true

func dryFire():
	if not ammoNode:
		return
	
	if ammoNode.currentAmmo > 0:
		return
	
	if Input.is_action_just_pressed("use_tool"):
		emptySound.play()
