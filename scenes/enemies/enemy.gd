extends CharacterBody2D

@export var enemy_definition : Enemy

#Parameters
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var player : CharacterBody2D
@onready var player_detector : RayCast2D = %PlayerDetector

#State
var target : Vector2
var player_detected : bool
var facing_right : bool

func _ready():
	player_detector.target_position = Vector2.RIGHT * enemy_definition.detection_range
	

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
		
	

# State Controllers

func detect_player():
	player_detector.look_at(player.global_position)
	if (absf(player_detector.rotation) > enemy_definition.max_detection_angle and facing_right or
		absf(player_detector.rotation) < enemy_definition.max_detection_angle and not facing_right):
		return
		
	
	if player_detector.get_collider() == player:
		player_detected = true
		print("player detected")
		
	else:
		player_detected = false
		
	
