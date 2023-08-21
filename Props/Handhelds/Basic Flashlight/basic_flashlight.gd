extends Node3D

var state = "off"

@onready var click = $clickSound

func _process(delta):
	
	if Input.is_action_just_pressed("flashlight") and state == "off" :
		visible = true
		state = "on"
		click.play()
	elif Input.is_action_just_pressed("flashlight") and state == "on" :
		visible = false
		state = "off"
		click.play()
