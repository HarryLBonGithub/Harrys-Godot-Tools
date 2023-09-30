extends Node

class_name Ammo

@export var ammoType = "generic"
@export var maxAmmo = 10
@export var currentAmmo = 10

var empty = false

func _process(delta):
	if currentAmmo <=0:
		empty = true

func reload():
	currentAmmo = maxAmmo
