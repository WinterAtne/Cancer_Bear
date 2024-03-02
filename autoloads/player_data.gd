extends Node

var player_instance : Player

func set_player(player : Player) -> void:
	if player_instance:
		player.queue_free()
		return
	
	player_instance = player
	
