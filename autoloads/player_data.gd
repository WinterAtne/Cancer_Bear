extends Node

var player_instance : Player

func set_player(player : Player) -> void:
	if player_instance:
		player.queue_free()
		return
	
	player_instance = player
	

func pause_player(function : Callable) -> void:
	PlayerData.player_instance.set_physics_process(false)
	await get_tree().physics_frame
	function.call()
	await get_tree().physics_frame
	player_instance.set_physics_process(true)
	
