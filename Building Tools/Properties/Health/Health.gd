extends Node

signal hit
signal ko
signal healed

@export var maxHealth = 30
@export var currentHealth = 30

@export var healthUI : ProgressBar
@export var owningNode : Node

func _ready():
	if healthUI:
		healthUI.max_value = maxHealth
		healthUI.value = currentHealth

func take_damage(damage):
	currentHealth -= damage
	
	if healthUI:
		healthUI.value = currentHealth
	
	if currentHealth <= 0:
		if owningNode:
			owningNode.queue_free()
