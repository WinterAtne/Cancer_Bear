extends CharacterBody2D
class_name Player

#Parameters
var speed : float = 300.0
var acceleration : float = 1200

var jump_velocity : float = -650.0
var jump_cancel_multiple : float = .3333333
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.34
var max_fall_velocity : float = 2000

@onready var camera : Camera2D = %Camera2D
@onready var spell_caster : SpellCaster = %SpellCaster
@onready var animator : AnimationPlayer = %AnimationPlayer
@onready var sprite : Sprite2D = %Sprite
@onready var hitbox : HitBox = %HitBox

#State
var jump_buffered : bool = false
var jump_canceled : bool = false

var facing_right : bool = true

#Signal
signal player_hit(damage : int, health : int)
signal player_healed(health : int)
signal player_died

func _ready() -> void:
	PlayerData.set_player(self)
	
	hitbox.hit.connect(take_damage.bind())
	hitbox.died.connect(die.bind())
	

func _physics_process(delta) -> void:
	vertical_movement(delta)
	horizontal_movement(delta)
	
	cast_spells()
	
	move_and_slide()
	
	animate()
	

#Movement
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
		
	

func animate() -> void:
	if velocity.x != 0:
		animator.play("upright_walk")
		#=1 when velocity = speed
		animator.speed_scale = velocity.x / speed
		
	else:
		animator.play("idle_0")
		animator.speed_scale = 0.5
		
	
	if velocity.x < 0 and facing_right:
		facing_right = false
		sprite.flip_h = !facing_right
		
	elif velocity.x > 0 and not facing_right:
		facing_right = true
		sprite.flip_h = !facing_right
		
	

#Spell Casting
func cast_spells() -> void:
	if Input.is_action_just_pressed("spell_1"):
		spell_caster.use_spell(0)
		
	if Input.is_action_just_pressed("spell_2"):
		spell_caster.use_spell(1)
		
	if Input.is_action_just_pressed("spell_3"):
		spell_caster.use_spell(2)
		
	if Input.is_action_just_pressed("spell_4"):
		spell_caster.use_spell(3)
		
	if Input.is_action_just_pressed("spell_5"):
		spell_caster.use_spell(4)
		
	

#Health & Damage
func heal(health : int) -> void:
	player_healed.emit(health)
	

func take_damage(damage_profile : DamageProfile, health : int, normal : Vector2) -> void:
	player_hit.emit(damage_profile.damage, health)
	velocity += normal * damage_profile.knockback
	

func die() -> void:
	player_died.emit()
	reset_player.call_deferred()
	

#Utilities
func reset_player() -> void:
	#This function is used when the player is respawned
	hitbox.heal(99)
	spell_caster.give_aberration(-99)
	
