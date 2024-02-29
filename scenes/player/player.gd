extends CharacterBody2D

#Parameters
var speed : float = 300.0
var acceleration : float = 1200

var jump_velocity : float = -800.0
var jump_cancel_multiple : float = .3333333
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var max_fall_velocity : float = 1200

#State
var jump_buffered : bool = false
var jump_canceled : bool = false

func _physics_process(delta):
	vertical_movement(delta)
	horizontal_movement(delta)
	
	move_and_slide()
	

func horizontal_movement(delta : float) -> void:
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction, delta * acceleration)
		
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)
		
	

func vertical_movement(delta : float) -> void:
	#Input:
	if Input.is_action_just_pressed("up"):
		jump_buffered = true
		jump_canceled = false
		
	elif Input.is_action_just_released("up"):
		jump_buffered = false
		jump_canceled = true
		
	
	#Actual Movement
	if is_on_floor():
		if jump_buffered:
			velocity.y = jump_velocity
			jump_buffered = false
			
		
		return
		
	
	if jump_canceled and velocity.y < 0:
		velocity.y *= jump_cancel_multiple
		jump_canceled = false
		return
		
	
	#Ensures we don't start falling really fast
	if velocity.y < max_fall_velocity:
		velocity.y += gravity * delta
		
	
