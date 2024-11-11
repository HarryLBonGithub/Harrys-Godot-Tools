extends CharacterBody3D

@onready var movement_node = $MovementInputs
@onready var animation_controller = $AnimationController
@onready var animation_tree = $MeshRoot/AnimationTree

var current_action = ""

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
