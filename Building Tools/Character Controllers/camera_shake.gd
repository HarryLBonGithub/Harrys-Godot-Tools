extends Camera3D



@export var shakeRateReduction = 1.0
@export var noise : FastNoiseLite
# add a FastNoiseLite
#type: simplex
#seed 0
#frequency 0.1
#octaves 4
@export var noise_speed = 50.0

@export var max_x = 10.0
@export var max_y = 10.0
@export var max_z = 5.0

var shake = 0.0
var time = 0.0

@onready var initialRot = rotation_degrees

func _process(delta):
	time += delta
	shake = max(shake - delta * shakeRateReduction, 0.0)
	
	rotation_degrees.x = initialRot.x + max_x * shake_intensity() * get_noise_from_seed(0)
	rotation_degrees.y = initialRot.y + max_y * shake_intensity() * get_noise_from_seed(1)
	rotation_degrees.z = initialRot.z + max_z * shake_intensity() * get_noise_from_seed(2)
	
	if Input.is_action_just_pressed("test_input"):
		add_shake(0.5)

func add_shake(shake_amount: float):
	shake = clamp(shake_amount + shake, 0.0, 1.0)

func shake_intensity() -> float:
	return shake * shake

func get_noise_from_seed(_seed) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
