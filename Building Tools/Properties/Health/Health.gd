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
	
	emit_signal("hit")
	
	if healthUI:
		healthUI.value = currentHealth
	
	if currentHealth <= 0:
		emit_signal("ko")

func heal_damage(damage):
	if currentHealth >= maxHealth:
		return
	
	emit_signal("healed")
	
	var toHeal = damage
	
	if toHeal + currentHealth > maxHealth:
		toHeal = maxHealth - currentHealth
		
	
	currentHealth += toHeal
	
	if healthUI:
		healthUI.value = currentHealth
