extends Node2D


@export var levels : Array[Level]
var current_level_index : int = 0
var current_level : Node2D

func _ready() -> void:
	start_level(0)
	
	for n in 80:
		await get_tree().process_frame
		
	
	start_level(1)
	

func restart_level() -> void:
	start_level(current_level_index)
	

func start_level(index : int) -> void:
	current_level_index = index
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited #errors may arise if we don't wait until the object is freed
		
	
	current_level = levels[current_level_index].scene.instantiate()
	add_child(current_level)
	
	PlayerData.pause_player(
		func () -> void:
			PlayerData.player_instance.position = levels[current_level_index].player_position[0]
			
	)
	
