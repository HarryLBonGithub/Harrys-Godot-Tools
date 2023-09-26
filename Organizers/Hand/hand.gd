extends Node3D

var belt = []

@onready var activeTool = 0

@export var ammoUI : AmmoTracker

func _ready():
	
	belt = get_children()
	
	for item in belt:
		item.active = false
		item.visible = false
	
	belt[activeTool].active = true
	belt[activeTool].visible = true
	
	if ammoUI:
		ammoUI.toolName.text = str(belt[activeTool].toolName)
		ammoUI.max.text = str(belt[activeTool].maxAmmo)
		ammoUI.current.text = str(belt[activeTool].currentAmmo)

func _process(delta):
	updateUI()


func updateUI():
	if !ammoUI:
		return
	
	if Input.is_action_pressed("use_tool"):
		ammoUI.max.text = str(belt[activeTool].maxAmmo)
		ammoUI.current.text = str(belt[activeTool].currentAmmo)
	
