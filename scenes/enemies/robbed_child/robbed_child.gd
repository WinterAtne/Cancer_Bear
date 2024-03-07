extends EnemyController

func _physics_process(delta):
	if player_detected:
		target = PlayerData.player_instance.position
		
	
	
	flip_on_direction()
	super._physics_process(delta)
	
