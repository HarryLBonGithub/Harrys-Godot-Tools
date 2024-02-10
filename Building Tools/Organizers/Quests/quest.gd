class_name Quest
extends Resource

@export var questName: String
@export var description: String
@export var summary: String

@export var reward: Reward

@export var keyToPress: String
@export var killTarget: String
@export var itemToCollect: Resource

@export var progressTarget: float

var progressCount = 0.0

var active = false
var completed = false
var failed = false
