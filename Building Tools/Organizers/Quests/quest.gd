extends Node

class_name Quest

@export var questName = ""
@export var summary = ""
@export var description = ""

var given = false
var active = false
var completed = false
var delivered = false
var failed = false

func giveTo(target):
	reparent(target)

func activeToggle():
	if active:
		active = false
	else:
		active = true

func completedToggle():
	if completed:
		completed = false
	else:
		completed = true

func deliveredToggle():
	if delivered:
		delivered = false
	else:
		delivered = true
		
func failedToggle():
	if failed:
		failed = false
	else:
		failed = true
