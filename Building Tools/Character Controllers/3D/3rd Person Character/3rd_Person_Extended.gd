extends CharacterBody3D

@onready var movement_node = $MovementInputs
@onready var animation_controller = $AnimationController
@onready var animation_tree = $MeshRoot/AnimationTree

func _input(event):
	if event.is_action_pressed("interact"):
		movement_node.halt()
		movement_node.movement_enabled = false
		animation_tree["parameters/action_oneshot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "wave":
		movement_node.movement_enabled = true
