extends Node

signal hit
signal ko
signal healed

@export var maxHealth = 30
@export var currentHealth = 30

func take_damage(damage):
	currentHealth -= damage
	
	if currentHealth <= 0:
		var parent = get_parent()
		parent.queue_free()
