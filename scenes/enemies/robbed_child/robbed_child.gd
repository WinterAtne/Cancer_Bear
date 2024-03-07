extends EnemyController

@export var blood_effect : PackedScene

func _physics_process(delta):
	if player_detected:
		target = PlayerData.player_instance.position
		
	
	
	flip_on_direction()
	super._physics_process(delta)
	

func _take_damage(damage_profile : DamageProfile, health : int, normal : Vector2) -> void:
	var effect = blood_effect.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
