extends CharacterBody2D

#Parameters
var speed : float = 300
var acceleration : float = 2000

var navigation_success_distance : float = 15

var can_fly : bool = false
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

#State
@export var target : Vector2

func _physics_process(delta) -> void:
	var direction : Vector2 = position.direction_to(target)
	
	horizontal_movement(delta, direction.x)
	vertical_movement(delta, direction.y)
	
	move_and_slide()
	

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
		
	
