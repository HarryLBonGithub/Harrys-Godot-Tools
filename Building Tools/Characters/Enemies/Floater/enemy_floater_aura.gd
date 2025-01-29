extends CharacterBody3D

@export var chargeUpTime = 3
@export var attackDamage = 5
@export var movementSpeed = 1

@onready var fillerAnimations = $MeshRoot_Filler/FillerAnimations
@onready var attackTimer = $AttackTimer

var target : Node3D

#This is a creature or entity that waits in one spot, detects an enemy that gets too close, begins charging an attack, then damages anything if that charge up finishes

#Add a way for it to pursue a player that it has line of sign in a given range to
#Add a way for it to damage any entities with health nearby, but only be triggered by those on an 'enemies' list
#Add a way to show more interesting animations


func _ready():
	attackTimer.wait_time = chargeUpTime

#if a player approaches this entity, start the attack timer, show an animation change to charging up, and log the player as a target
func _on_attack_detection_area_body_entered(body):
	if body.is_in_group("player"):
		fillerAnimations.play("charge_up")
		attackTimer.start()
		target = body

#if a player moves out of a threat range, stop the timer, return to a waiting animation, and remove the player as a target
func _on_attack_detection_area_body_exited(body):
	if body.is_in_group("player"):
		fillerAnimations.play("waiting")
		attackTimer.stop()
		target = null

#when the timer finishes, play the attack animation and damage the currently logged target (usually player)
func _on_attack_timer_timeout():
	fillerAnimations.play("attack")
	
	if target == null:
		return
	if target.has_node("Health"):
			var targetHealth = target.find_child("Health")
			targetHealth.take_damage(attackDamage)
			emit_signal("damageDelivered")
	
func _on_filler_animations_animation_finished(anim_name):
	if anim_name == "attack":
		if target != null:
			attackTimer.start()
			fillerAnimations.play("charge_up")

		else:
			fillerAnimations.play("waiting")
