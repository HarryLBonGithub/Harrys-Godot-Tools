extends Node3D

@onready var player = $FPSCharacterController

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
