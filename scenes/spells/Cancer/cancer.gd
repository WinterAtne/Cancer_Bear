extends Node2D

#Parameters
@export var damage_profile : DamageProfile
@export var time_between_effects : float = 0.75

#State
enum State {
	searching,
	damaging, #When in damaging state we are guarentteed to be the child of a hitbox
}

var state : State = State.searching

func _ready():
	position = (get_viewport().get_mouse_position() 
			+ PlayerData.player_instance.camera.global_position
			- (get_viewport_rect().size / 2))
	

func _physics_process(delta) -> void:
	if state == State.searching:
		position = (get_viewport().get_mouse_position() 
			+ PlayerData.player_instance.camera.global_position
			- (get_viewport_rect().size / 2))
		
		
	

func _on_area_2d_area_entered(area):
	if area is HitBox:
		if state == State.searching:
			%Area2D.queue_free()
			state = State.damaging
			damage(area)
			
			
		
	

func damage(infected : HitBox) -> void:
	self.reparent.call_deferred(infected)
	await get_tree().physics_frame
	var is_infected : bool = true
	while(is_infected):
		infected.damage_immediate(damage_profile, Vector2.ZERO)
		await get_tree().create_timer(time_between_effects).timeout
		
	
