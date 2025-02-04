extends CharacterBody3D

@export var attackDamage = 5
@export var movementSpeed = 1

@onready var stateMachine = $MeshRoot/AnimationTree.get("parameters/StateMachine/playback")
@onready var collider = $CharacterCollider
@onready var detector = $AttackDetectionArea/AttackDetectionCollider

var dead = false

var target : Node3D

#This is a creature or entity that waits in one spot, detects an enemy that gets too close, begins charging an attack, then damages anything if that charge up finishes

#Add a way for it to pursue a player that it has line of sign in a given range to
#Add a way for it to damage any entities with health nearby, but only be triggered by those on an 'enemies' list
#Add a way to show more interesting animations

	
#if any animation finishes, and there is a player nearby, start charging again
#if the animation was 'die' remove the character
#otherwise, return to idling
# if the animation was 'attack' damaged the saved target
func _on_animation_tree_animation_finished(anim_name):
	
	if target != null:
		if anim_name == "attack" and target.has_node("Health"):
			var targetHealth = target.find_child("Health")
			targetHealth.take_damage(attackDamage)
			emit_signal("damageDelivered")
		stateMachine.travel("charge")
	elif anim_name == "die":
		queue_free()
	else:
		stateMachine.travel("idle")
		
	

func _on_health_hit():
	if dead:
		return
	stateMachine.travel("damage")

func _on_health_ko():
	dead = true
	target = null
	collider.set_deferred("disabled", true)
	detector.set_deferred("disabled", true)
	stateMachine.travel("die")

#if a player approaches this entity, show an animation change to charging up, and log the player as a target
func _on_attack_detection_area_area_entered(area):
	if dead:
		return
	if area.is_in_group("player"):
		stateMachine.travel("charge")
		target = area.get_parent()


#if a player moves out of a threat range, stop the timer, return to an idle animation, and remove the player as a target
func _on_attack_detection_area_area_exited(area):
	if dead:
		return
	
	if area.is_in_group("player"):
		stateMachine.travel("idle")
		target = null
