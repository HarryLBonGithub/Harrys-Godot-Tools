extends Node

signal interacted

func interact():
	emit_signal("interacted")
	
