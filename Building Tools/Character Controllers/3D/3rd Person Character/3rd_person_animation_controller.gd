extends Node

@export var animation_tree : AnimationTree
@export var main_node : CharacterBody3D

var on_floor_blend : float = 1
var on_floor_blend_target : float = 1

var tween : Tween


func _physics_process(delta):
	
	#blend in the falling animation when the player is falling
	on_floor_blend_target = 1 if main_node.is_on_floor() else 0
	on_floor_blend = lerp(on_floor_blend, on_floor_blend_target, 10 * delta)
	animation_tree["parameters/on_floor_blend/blend_amount"] = on_floor_blend

func _on_movement_inputs_set_movement_state(_movement_state):
	if tween:
		tween.kill()
		
	tween = create_tween()
	#tween from the current position in the animation tree and the movement state ID position on the tree
	tween.tween_property(animation_tree, "parameters/movement_blend/blend_position", _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree,"parameters/movement_anim_speed/scale", _movement_state.animation_speed, 0.7)


func _on_movement_inputs_pressed_jump(jump_state):
	#takes the passed in jump state, takes the name from it, can fires the oneshot with that name in the animation tree
	animation_tree["parameters/" + jump_state.animation_name + "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
