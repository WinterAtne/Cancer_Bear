extends Area2D
class_name Grabbable

#parameters
const SPEED : float = 2000
const ACCELERATION : float = 18000
const MAX_TIME : float = 2

#State
var rigidbody : bool = false
var characterbody : bool = false
var is_grabbed : bool = false # if true we are assured the parent is paused
var grabber : Grab

func _ready():
	if owner is RigidBody2D:
		rigidbody = true
		
	elif owner is CharacterBody2D:
		characterbody = true
		
	else:
		push_warning("Owner of Grabbable " + str(owner) + "is not of type Characterbody2D or rigidbody2D")
		queue_free()
		
	

func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("action_primary") and grabber != null:
		grabber.queue_free()
		is_grabbed = true
		
		get_tree().create_timer(MAX_TIME).timeout.connect(
			func ():
				is_grabbed = false
				if owner.has_method("pause"): #we run this here to to make it clear what we're doing
					owner.pause(false)
					
				
		)
		
		if owner.has_method("pause"):
			owner.pause(true)
			
		else:
			push_warning("Owner of Grabbable " + str(owner) + "does not have method \"paused\"")
			queue_free()
			
		
		
		
	elif Input.is_action_just_released("action_primary") and is_grabbed:
		is_grabbed = false
		if owner.has_method("pause"): # we run this here to to make it clear what we're doing
			owner.pause(false)
			
		
	
	if is_grabbed:
		var direction = direction_to_mouse()
		var adjusted_speed = (distance_to_mouse() / SPEED)
		owner.velocity = owner.velocity.move_toward(direction * SPEED, delta * ACCELERATION)
		owner.move_and_slide()
		
		
	
	

func _on_area_entered(area) -> void:
	if not area is Grab:
		return
		
	
	grabber = area
	

func _on_area_exited(area) -> void:
	if not area is Grab:
		return
		
	
	grabber = null
	

func direction_to_mouse() -> Vector2:
	var mouse_position = (get_viewport().get_mouse_position() 
		+ PlayerData.player_instance.camera.global_position
		- (get_viewport_rect().size / 2))
	
	return global_position.direction_to(mouse_position)
	

func distance_to_mouse() -> float:
	var mouse_position = (get_viewport().get_mouse_position() 
		+ PlayerData.player_instance.camera.global_position
		- (get_viewport_rect().size / 2))
	
	return global_position.distance_to(mouse_position)
	
