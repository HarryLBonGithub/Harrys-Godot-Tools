extends RigidBody3D

class_name Projectile

@export var speed = 25
@export var lifetime : Timer

func _ready():
	apply_impulse(-transform.basis.z * speed, transform.basis.z)
	
	if lifetime:
		lifetime.autostart = true
		lifetime.one_shot = true

func _process(delta):
	if lifetime:
		if lifetime.is_stopped():
			queue_free()
