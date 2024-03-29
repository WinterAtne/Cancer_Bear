extends Node2D


@export var levels : Array[Level] = []
var current_level_index : int = 0
var current_level : Node2D

signal start
signal restart

func _ready() -> void:
	start_level(0, 0)
	PlayerData.player_instance.player_died.connect(restart_level.bind())
	

func restart_level() -> void:
	restart.emit()
	start_level(current_level_index, 0)
	

func start_level(index : int, entrance : int) -> void:
	start.emit()
	current_level_index = index
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited #errors may arise if we don't wait until the object is freed
		
	
	current_level = levels[current_level_index].scene.instantiate()
	add_child(current_level)
	
	PlayerData.pause_player(
		func () -> void:
			PlayerData.player_instance.position = levels[current_level_index].player_position[entrance]
			PlayerData.player_instance.velocity = Vector2.ZERO
			
	)
	
