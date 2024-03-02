extends Area2D
class_name HitBox

@export var health_profile : Health_Profile

signal hit(damage_profile : DamageProfile, health : int, normal : Vector2)
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
			return
			
		
		damage_immediate(area.damage_profile, (global_position - area.global_position).normalized())
		
		manage_invulnerable()
		
	

func damage_immediate(damage_profile : DamageProfile, normal : Vector2):
	current_health -= damage_profile.damage
	hit.emit(
		damage_profile,
		current_health,
		normal)
	if current_health <= 0:
		died.emit()
		
	

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
		
	
