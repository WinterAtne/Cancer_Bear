extends TempObject

func _ready():
	reparent(PlayerData.player_instance)
	$GPUParticles2D.emitting = true;
	if not PlayerData.player_instance.facing_right:
		scale.x = -1
		
	
	await get_tree().process_frame # we wait to make sure the reparent happens
	position = position + ((1 if PlayerData.player_instance.facing_right else -1) * Vector2.RIGHT * 48)
	super._ready()
	
