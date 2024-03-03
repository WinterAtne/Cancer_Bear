extends TempObject

func _ready():
	reparent(PlayerData.player_instance)
	await get_tree().process_frame # we wait to make sure the reparent happens
	position = position + ((1 if PlayerData.player_instance.facing_right else -1) * Vector2.RIGHT * 48)
	super._ready()
	
