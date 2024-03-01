extends CharacterBody2D

#Parameters
var speed : float = 300
var acceleration : float = 2000

var navigation_success_distance : float = 15

#State
@export var target : Vector2

func _physics_process(delta) -> void:
	horizontal_movement(delta)
	
	move_and_slide()
	

func horizontal_movement(delta) -> void:
	if position.distance_to(target) >= navigation_success_distance:
		var direction : float = position.direction_to(target).x
		velocity.x = move_toward(velocity.x, speed * direction, delta * acceleration)
		
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)
	
	
