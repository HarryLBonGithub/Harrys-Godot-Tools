extends CharacterBody3D

#This is a creature or entity that waits in one spot, detects an enemy that gets too close, begins charging an attack, then damages anything if that charge up finishes

#Add a way for it to damage any entities with health nearby, but only be triggered by those on an 'enemies' list
#Add particle effect
#Add sound

@export var attackDamage = 5
@export var movementSpeed = 1
@export var movementEnabled : bool = false

@onready var stateMachine = $MeshRoot/AnimationTree.get("parameters/StateMachine/playback")
@onready var collider = $CharacterCollider
@onready var detector = $AttackDetectionArea/AttackDetectionCollider
@onready var lineOfSight = $LineOfSight
@onready var proximityChecker = $ProximityChecker

var dead = false

var target : Node3D

var closeEnough =  false

func _process(delta):
	check_proximity()
	pursue(delta)

#if any animation finishes, and there is a player nearby, start charging again
#if the animation was 'die' remove the character
#otherwise, return to idling
# if the animation was 'attack' damaged the saved target
func _on_animation_tree_animation_finished(anim_name):
	if target != null:
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

func pursue(_delta):
	
	if dead:
		return
	
	if movementEnabled == false:
		return
		
	if closeEnough == true:
		return
	
	lineOfSight.target()
	
	lineOfSight.force_raycast_update()
	if lineOfSight.is_colliding():
		var los_target = lineOfSight.get_collider()
		if los_target.is_in_group("player"):
			global_transform.origin = global_transform.origin.move_toward(los_target.global_transform.origin, movementSpeed * _delta)

func check_proximity():
	if movementEnabled == false:
		return
	
	proximityChecker.target()
	
	proximityChecker.force_raycast_update()
	
	if proximityChecker.is_colliding():
		closeEnough = true
	else:
		closeEnough = false

func _on_animation_tree_animation_started(anim_name):
	if target == null:
		return
	
	if anim_name == "attack" and target.has_node("Health"):
		var targetHealth = target.find_child("Health")
		targetHealth.take_damage(attackDamage)
		emit_signal("damageDelivered")
