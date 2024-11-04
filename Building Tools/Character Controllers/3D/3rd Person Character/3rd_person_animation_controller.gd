extends Node

@export var animation_tree : AnimationTree
@export var main_node : CharacterBody3D

var on_floor_blend : float = 1
var on_floor_blend_target : float = 1

var tween : Tween

var current_stance_name = "upright"

var movement_direction : Vector3

func _physics_process(delta):
	
	#blend in the falling animation when the player is falling
	on_floor_blend_target = 1 if main_node.is_on_floor() else 0
	on_floor_blend = lerp(on_floor_blend, on_floor_blend_target, 10 * delta)
	animation_tree["parameters/on_floor_blend/blend_amount"] = on_floor_blend

func _on_movement_inputs_pressed_jump(jump_state):
	#takes the passed in jump state, takes the name from it, can fires the oneshot with that name in the animation tree
	animation_tree["parameters/" + jump_state.animation_name + "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _on_movement_inputs_changed_movement_state(_movement_state):
	if tween:
		tween.kill()
		
	tween = create_tween()
	#tween from the current position in the animation tree and the movement state ID position on the tree
	tween.tween_property(animation_tree, "parameters/" + current_stance_name + "_movement_blend/blend_position", _movement_state.id, 0.25)
	var direction_2D = Vector2(movement_direction.x, -movement_direction.z)
	tween.parallel().tween_property(animation_tree,"parameters/strafing_movement_blend/blend_position", direction_2D,0.25)
	tween.parallel().tween_property(animation_tree,"parameters/movement_anim_speed/scale", _movement_state.animation_speed, 0.7)
	
	

func _on_movement_inputs_changed_stance(stance):
	animation_tree["parameters/stance_transition/transition_request"] = stance.name
	current_stance_name = stance.name

func _on_movement_inputs_changed_movement_direction(_movement_direction):
	movement_direction =_movement_direction

func _on_movement_inputs_strafing_toggle(_strafing):
	if _strafing == true:
		animation_tree["parameters/strafing_transition/transition_request"] = "strafing"
	else:
		animation_tree["parameters/strafing_transition/transition_request"] = "not_strafing"
