extends Node
@export var lights : Array[Node3D]

@export var startsOn = true

var on = true

func _ready():
	if len(lights) <=0:
		return
	
	if startsOn:
		
		for light in lights:
			
			if light is Light3D:
				light.visible = true
			
			elif light.get_child_count() > 0:
				var children = light.get_children()
				for child in children:
					if child is Light3D:
						child.visible = true
		on = true
	else:
		for light in lights:
			
			if light is Light3D:
				light.visible = false
			
			elif light.get_child_count() > 0:
				var children = light.get_children()
				for child in children:
					if child is Light3D:
						child.visible = false
		on = false

func toggle():
	
	if len(lights) <=0:
		return
	
	if on:
		for light in lights:
			
			if light is Light3D:
				light.visible = false
			
			elif light.get_child_count() > 0:
				var children = light.get_children()
				for child in children:
					if child is Light3D:
						child.visible = false
		on = false
		
	else:
		for light in lights:
			
			if light is Light3D:
				light.visible = true
			
			elif light.get_child_count() > 0:
				var children = light.get_children()
				for child in children:
					if child is Light3D:
						child.visible = true
		on = true
