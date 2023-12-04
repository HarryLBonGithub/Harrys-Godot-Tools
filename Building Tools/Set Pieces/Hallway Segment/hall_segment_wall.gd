extends StaticBody3D

@onready var detectorRay = $NeighborDetector

func _ready():
	detectorRay.force_raycast_update()
	
	if detectorRay.is_colliding():
		queue_free()
