extends Area2D
class_name HitBox

@export var health_profile : Health_Profile

signal hit(damage : int,  health : int, normal : Vector2, knockback : float)
signal died
signal invulnerable
signal not_invulnerable

var current_health : int = -1
var health_is_ready : bool = false
var can_take_damage : bool = true

func _ready() -> void:
	await owner.ready # We get our health_profile from the owner
	current_health = health_profile.max_health
	health_is_ready = true
	

func _on_area_entered(area) -> void:
	if area is HurtBox:
		if not health_is_ready: # We get our health_profile from the owner
			await owner.ready
			
		
		if !can_take_damage:
			print("cannot take damage")
			return
		
		current_health -= area.damage
		hit.emit(area.damage, 
			current_health, 
			(global_position - area.global_position).normalized(),
			area.knockback)
		if current_health <= 0:
			died.emit()
			
		
		manage_invulnerable()
		
	

func heal(amount : int) -> void:
	if not health_is_ready: # We get our health_profile from the owner
			await owner.ready
			
	
	current_health += amount
	if current_health > health_profile.max_health:
		current_health = health_profile.max_health
	

func manage_invulnerable():
	if health_profile.invulnerable_seconds != -1:
		can_take_damage = false
		invulnerable.emit()
		await get_tree().create_timer(health_profile.invulnerable_seconds).timeout
		not_invulnerable.emit()
		can_take_damage = true#Changed after signal so state elsewhere can communicate to the player
		
	
