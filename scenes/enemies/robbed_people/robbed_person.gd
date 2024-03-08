extends EnemyController

@export var blood_effect : PackedScene
@export var desired_distance : float = 450
@export var minimum_distance : float = 150
@export var allowed_y_distance : float = 200

@export var spear : PackedScene
@export var spear_speed : float = 800

@onready var attack_timer : Timer = $AttackTimer

func _physics_process(delta):
	flip_on_direction()
	super._physics_process(delta)
	
	if not player_detected:
		return
		
	
	if absf(position.y - PlayerData.player_instance.position.y) > allowed_y_distance:
		return
		
	
	if position.distance_to(PlayerData.player_instance.position) < minimum_distance:
		var player_direction : Vector2 = position.direction_to(PlayerData.player_instance.position)
		target = (PlayerData.player_instance.position - 
			(player_direction.x * desired_distance * Vector2.RIGHT))
		
	elif target.distance_to(PlayerData.player_instance.position) < desired_distance:
		target = position
		
	
	

func _take_damage(damage_profile : DamageProfile, health : int, normal : Vector2) -> void:
	var effect = blood_effect.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
	

func _on_player_detected() -> void:
	attack_timer.start()
	while player_detected:
		var instance_spear : RigidBody2D = spear.instantiate()
		get_parent().add_child(instance_spear)
		instance_spear.global_position = global_position + (Vector2.UP * 64)
		instance_spear.linear_velocity = (position.direction_to(PlayerData.player_instance.position 
			+ (PlayerData.height * Vector2.UP)) 
			* spear_speed)
		
		instance_spear.rotate(get_angle_to(PlayerData.player_instance.position)) 
		
		await attack_timer.timeout
		
	
