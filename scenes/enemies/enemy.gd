extends CharacterBody2D

#Parameters
var speed : float = 300
var acceleration : float = 2000

var navigation_success_distance : float = 15

var can_fly : bool = false

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var player : CharacterBody2D
var detection_range : float = 200
var max_detection_angle : float = PI/4
@onready var player_detector : RayCast2D = %PlayerDetector

#State
var target : Vector2
var player_detected : bool = false
var facing_right : bool = true

func _ready():
	player_detector.target_position = Vector2.RIGHT * detection_range
	

func _physics_process(delta) -> void:
	var direction : Vector2 = position.direction_to(target)
	
	horizontal_movement(delta, direction.x)
	vertical_movement(delta, direction.y)
	
	move_and_slide()
	
	detect_player() # we want to check, having completed or previous movement
	

#Movement

func horizontal_movement(delta : float, direction : float) -> void:
	if position.distance_to(target) >= navigation_success_distance:
		velocity.x = move_toward(velocity.x, speed * direction, delta * acceleration)
		
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)
		
	

func vertical_movement(delta : float, direction : float) -> void:
	if not can_fly:
		velocity.y += gravity * delta
		return
		
	
	if position.distance_to(target) >= navigation_success_distance:
		velocity.y = move_toward(velocity.y, speed * direction, delta * acceleration)
		
	else:
		velocity.y = move_toward(velocity.y, 0, delta * acceleration)
		
	

# State Controllers

func detect_player():
	player_detector.look_at(player.global_position)
	if (absf(player_detector.rotation) > max_detection_angle and facing_right or
		absf(player_detector.rotation) < max_detection_angle and not facing_right):
		return
		
	
	if player_detector.get_collider() == player:
		player_detected = true
		print("player detected")
		
	else:
		player_detected = false
		
	
