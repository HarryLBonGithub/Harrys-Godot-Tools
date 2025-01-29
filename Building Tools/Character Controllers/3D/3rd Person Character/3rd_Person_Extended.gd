extends CharacterBody3D

@onready var movement_node = $MovementInputs
@onready var animation_controller = $AnimationController
@onready var input_controller = $MovementInputs
@onready var animation_tree = $MeshRoot/AnimationTree
@onready var simple_blaster = $MeshRoot/Lowpoly_Cartoon_Human_V4/Humanoid_Armature/Skeleton3D/RightHandAttach/RightHandOffset/SimpleBlaster

var current_stance_name = "upright"
var current_movement_name = "idle"
var combat_mode = false
var current_action = ""
var tween : Tween
var alert = false


func _process(delta):
	if Input.is_action_just_pressed("debug_k"):
		input_controller.switch_combat_mode(true)
		simple_blaster.visible=true
		input_controller.toggle_alert(true)

	elif Input.is_action_just_pressed("holster") or Input.is_action_just_pressed("crouch"):
		simple_blaster.visible=false
		input_controller.switch_combat_mode(false)
		
	
	if Input.is_action_just_pressed("aim") and combat_mode==true:
		simple_blaster.active=true
	if Input.is_action_just_released("aim"):
		simple_blaster.active=false
		
func _input(event):
	
	return
	"""
	if event.is_action_pressed("interact"):
		
		if animation_tree.get_tree_root().get_node("action_animation").animation == current_action:
			return
		
		movement_node.halt()
		movement_node.movement_enabled = false
		animation_tree.get_tree_root().get_node("action_animation").animation = "shrug"
		current_action = "shrug"
		animation_tree["parameters/action_oneshot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	"""

func _on_animation_tree_animation_finished(anim_name):

	if anim_name == current_action:
		movement_node.movement_enabled = true
		current_action = ""
		movement_node.continue_movement()

func _on_movement_inputs_changed_movement_state(_movement_state):
	current_movement_name = _movement_state


func _on_movement_inputs_changed_stance(stance):
	current_stance_name=stance.name


func _on_movement_inputs_combat_mode_toggle(_combat_mode):
	combat_mode=_combat_mode
