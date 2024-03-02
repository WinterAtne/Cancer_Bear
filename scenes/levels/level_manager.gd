extends Node2D


@export var levels : Array[Level]
var current_level_index : int = 0
var current_level : Node2D

func _ready():
	start_level(0)
	

func restart_level():
	start_level(current_level_index)
	

func start_level(index : int):
	current_level_index = index
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited #errors may arise if we don't wait until the object is freed
		
	
	current_level = levels[current_level_index].scene.instantiate()
	add_child(current_level)
	
	#Set player position to player position
	#Depending on the door we entered through
	
