extends CharacterBody3D

@onready var movement_node = $MovementInputs
@onready var animation_controller = $AnimationController
@onready var animation_tree = $MeshRoot/AnimationTree
@onready var simple_blaster = $MeshRoot/Lowpoly_Cartoon_Human_V4/Humanoid_Armature/Skeleton3D/RightHandAttach/RightHandOffset/SimpleBlaster

var current_stance_name = "upright"
var current_movement_name = "idle"
var current_action = ""
var tween : Tween


func _process(delta):
	
	# set combat mode
	if Input.is_action_just_pressed("use_alt") and Input.is_action_pressed("run") == false:
		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.tween_property(animation_tree,"parameters/combat_mode_blend/blend_amount",1.0,0.25)
		animation_tree["parameters/combat_transition/transition_request"] = "aim"
		simple_blaster.active = true
		simple_blaster.visible = true
	
	if Input.is_action_just_released("use_alt"):
		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.tween_property(animation_tree,"parameters/combat_mode_blend/blend_amount",0.0,0.25)
		animation_tree["parameters/combat_transition/transition_request"] = "ready"
		simple_blaster.active = false
		simple_blaster.visible = false
		
		
	if Input.is_action_just_pressed("use_tool"):
		animation_tree["parameters/use_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _input(event):
	if event.is_action_pressed("interact"):
		
		if animation_tree.get_tree_root().get_node("action_animation").animation == current_action:
			return
		
		movement_node.halt()
		movement_node.movement_enabled = false
		animation_tree.get_tree_root().get_node("action_animation").animation = "shrug"
		current_action = "shrug"
		animation_tree["parameters/action_oneshot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == current_action:
		movement_node.movement_enabled = true
		current_action = ""



func _on_movement_inputs_changed_movement_state(_movement_state):
	current_movement_name = _movement_state


func _on_movement_inputs_changed_stance(stance):
	pass # Replace with function body.
