extends Node2D
class_name TempObject

@export var seconds_to_delete : float = 1

func _ready():
	await get_tree().create_timer(seconds_to_delete).timeout
	queue_free()
	
