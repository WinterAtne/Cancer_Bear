extends EnemyController

func _physics_process(delta):
	if player_detected:
		target = PlayerData.player_instance.position
	
	super._physics_process(delta)
	
