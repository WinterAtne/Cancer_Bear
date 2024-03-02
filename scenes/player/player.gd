extends CharacterBody2D

#Parameters
var speed : float = 300.0
var acceleration : float = 1200

var jump_velocity : float = -650.0
var jump_cancel_multiple : float = .3333333
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.34
var max_fall_velocity : float = 900

@onready var spell_caster : SpellCaster = %SpellCaster
@onready var animator : AnimationPlayer = %AnimationPlayer
@onready var sprite : Sprite2D = $Sprite

#State
var jump_buffered : bool = false
var jump_canceled : bool = false

var facing_right : bool = true

func _physics_process(delta):
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
		
	

func animate():
	if velocity.x != 0:
		animator.play("upright_walk")
		#=1 when velocity = speed
		animator.speed_scale = velocity.x / speed
		
	else:
		animator.play("idle_0")
		animator.speed_scale
		
	
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
		
	

