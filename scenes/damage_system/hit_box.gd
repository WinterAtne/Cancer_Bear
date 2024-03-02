extends Area2D
class_name HitBox

@export var health_profile : Health_Profile

signal hit(damage : int,  health : int)
signal died

var current_health : int = -1
var health_is_ready : bool = false

func _ready() -> void:
	await owner.ready # We get our health_profile from the owner
	current_health = health_profile.max_health
	health_is_ready = true
	

func _on_area_entered(area):
	if area is HurtBox:
		if not health_is_ready: # We get our health_profile from the owner
			await owner.ready
			
		
		current_health -= area.damage
		hit.emit(area.damage, current_health)
		if current_health <= 0:
			died.emit()
			
		
	
	

func heal(amount : int):
	if not health_is_ready: # We get our health_profile from the owner
			await owner.ready
			
	
	current_health += amount
	if current_health > health_profile.max_health:
		current_health = health_profile.max_health
	
