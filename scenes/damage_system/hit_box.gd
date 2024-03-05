extends Area2D
class_name HitBox

@export var health_profile : Health_Profile
@export var fall_damage_profile : DamageProfile

signal hit(damage_profile : DamageProfile, health : int, normal : Vector2)
signal healed(health : int)
signal died
signal invulnerable
signal not_invulnerable
signal unpaused

#State
var paused : bool = true
var current_health : int = -1
var health_is_ready : bool = false
var can_take_damage : bool = true
var is_rigid_body : bool = true

var last_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	owner.ready.connect(
		func () -> void:
			paused = false
			unpaused.emit()
			
	)
	
	if paused: await unpaused
	
	current_health = health_profile.max_health
	health_is_ready = true
	
	if not (owner is RigidBody2D or owner is CharacterBody2D):
		is_rigid_body = false
		
	

func _physics_process(delta):
	if is_rigid_body:
		do_velocity_damage()
		last_velocity = owner.velocity
		
	

func do_velocity_damage() -> void:
	var velocity_difference : float = last_velocity.length() - owner.velocity.length()
	
	if velocity_difference > health_profile.velocity_damage_threshold:
		damage_immediate(fall_damage_profile, (last_velocity).normalized())
		
	
	
	

func _on_area_entered(area) -> void:
	if paused: await unpaused
	
	if area is HurtBox:
		if !can_take_damage:
			return
			
		
		damage_immediate(area.damage_profile, (global_position - area.global_position).normalized())
		
		manage_invulnerable()
		
	

func damage_immediate(damage_profile : DamageProfile, normal : Vector2):
	if paused: await unpaused
	
	current_health -= damage_profile.damage
	hit.emit(
		damage_profile,
		current_health,
		normal)
	if current_health <= 0:
		died.emit()
		
	

func heal(amount : int) -> void:
	if paused: await unpaused
	
	current_health += amount
	if current_health > health_profile.max_health:
		current_health = health_profile.max_health
	
	healed.emit(current_health)
	

func manage_invulnerable():
	if paused: await unpaused
	
	if health_profile.invulnerable_seconds != -1:
		can_take_damage = false
		invulnerable.emit()
		await get_tree().create_timer(health_profile.invulnerable_seconds).timeout
		not_invulnerable.emit()
		can_take_damage = true#Changed after signal so state elsewhere can communicate to the player
		
	
