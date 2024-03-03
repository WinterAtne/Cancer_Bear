extends Interactable
class_name Edible

func _do_interaction():
	PlayerData.player_instance.spell_caster.give_aberration(-3)
	
	is_interactable = false
	queue_free.call_deferred()
	
