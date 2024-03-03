extends CharacterBody2D
class_name EnemyController

@export var enemy_definition : Enemy

#Parameters
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_detector : RayCast2D = %PlayerDetector

#State
var target : Vector2
var player_detected : bool
var facing_right : bool = true

func _ready() -> void:
	player_detector.target_position = Vector2.RIGHT * enemy_definition.detection_range
	%HitBox.health_profile = enemy_definition.health_profile
	%HitBox.hit.connect(_take_damage.bind())
	%HitBox.died.connect(_die.bind())
	

func _physics_process(delta) -> void:
	var direction : Vector2 = position.direction_to(target)
	
	horizontal_movement(delta, direction.x)
	vertical_movement(delta, direction.y)
	
	move_and_slide()
	
	detect_player() # we want to check, having completed or previous movement
	

#Movement

func horizontal_movement(delta : float, direction : float) -> void:
	if position.distance_to(target) >= enemy_definition.navigation_success_distance:
		velocity.x = move_toward(velocity.x, enemy_definition.speed * direction, delta * enemy_definition.acceleration)
		
	else:
		velocity.x = move_toward(velocity.x, 0, delta * enemy_definition.acceleration)
		
	

func vertical_movement(delta : float, direction : float) -> void:
	if not enemy_definition.can_fly:
		velocity.y += gravity * delta
		return
		
	
	if position.distance_to(target) >= enemy_definition.navigation_success_distance:
		velocity.y = move_toward(velocity.y, enemy_definition.speed * direction, delta * enemy_definition.acceleration)
		
	else:
		velocity.y = move_toward(velocity.y, 0, delta * enemy_definition.acceleration)
		
	

# State Controllers & utilities

func detect_player() -> void:
	var valid_angle : bool = false
	player_detector.look_at(PlayerData.player_instance.global_position + (Vector2.UP * 48))
	if absf(player_detector.rotation) < enemy_definition.max_detection_angle:
		valid_angle = true
		
	
	if player_detector.get_collider() == PlayerData.player_instance and valid_angle:
		player_detected = true
		return
		
	

func _take_damage(damage_profile : DamageProfile, health : int, normal : Vector2) -> void:
	pass
	

func _die() -> void:
	queue_free()
	pass
	

func flip_on_direction():
	if velocity.x < 0 and facing_right:
		facing_right = false
		scale.x = -1
		
	elif velocity.x > 0 and not facing_right:
		facing_right = true
		scale.x = -1
		
	
