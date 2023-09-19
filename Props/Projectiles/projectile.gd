extends RigidBody3D

@export var speed = 25

func _ready():
	apply_impulse(-transform.basis.z * speed, transform.basis.z)

func _on_lifetime_timeout():
	queue_free()
