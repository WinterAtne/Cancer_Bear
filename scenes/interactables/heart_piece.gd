extends Interactable

func _do_interaction() -> void:
	PlayerData.player_instance.hitbox.increase_max_health()
	get_parent().queue_free()
	
