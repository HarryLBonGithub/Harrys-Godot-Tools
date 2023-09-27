extends Node3D

var belt = []

@onready var activeTool = 0

@export var ammoUI : AmmoTracker

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

func _process(delta):
	if len(belt) < 1:
		return
	
	if Input.is_action_pressed("use_tool"):
		updateUI()
	cycleUp()

func updateUI():
	if !ammoUI:
		return
	if !belt[activeTool].has_node("Ammo"):
		ammoUI.toolName.text = "NA"
		ammoUI.max.text = "NA"
		ammoUI.current.text = "NA"
		return
	
	ammoUI.toolName.text = str(belt[activeTool].toolName)
	
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
		belt[activeTool].active = true
		belt[activeTool].visible = true
		updateUI()
