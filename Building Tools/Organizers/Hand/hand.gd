extends Node3D

var belt = []

@onready var activeTool = 0

@export var ammoUI : AmmoTracker
@export var targettingRay : RayCast3D

func _ready():
	
	belt = get_children()
	
	if len(belt) < 1:
		return
	
	for item in belt:
		item.active = false
		item.visible = false
	
	belt[activeTool].active = true
	belt[activeTool].visible = true
	
	updateUI()
	
	if targettingRay:
	
		for item in belt:
			if item.has_node("AdjustAim"):
				var aimAdjuster = item.find_child("AdjustAim")
				aimAdjuster.targettingRay = targettingRay

func _process(delta):
	if len(belt) < 1:
		return
	
	if Input.is_action_pressed("use_tool"):
		updateUI()
	
	cycleUp()
	cycleDown()

func updateUI():
	if !ammoUI:
		return
	ammoUI.toolName.text = str(belt[activeTool].toolName)
	if !belt[activeTool].has_node("Ammo"):
		
		ammoUI.max.text = "NA"
		ammoUI.current.text = "NA"
		return
	
	var toolAmmo = belt[activeTool].find_child("Ammo")
	
	ammoUI.max.text = str(toolAmmo.maxAmmo)
	ammoUI.current.text = str(toolAmmo.currentAmmo)
	
func cycleUp():
	if len(belt) < 1:
		return
	
	if Input.is_action_just_released("scroll_up"):
		belt[activeTool].active = false
		belt[activeTool].visible = false
		activeTool +=1
		if activeTool == len(belt):
			activeTool = 0
		belt[activeTool].active = true
		belt[activeTool].visible = true
		updateUI()

func cycleDown():
	if len(belt) < 1:
		return
	
	if Input.is_action_just_released("scroll_down"):
		belt[activeTool].active = false
		belt[activeTool].visible = false
		activeTool -=1
		if activeTool < 0:
			activeTool = len(belt) - 1		
		belt[activeTool].active = true
		belt[activeTool].visible = true
		updateUI()
