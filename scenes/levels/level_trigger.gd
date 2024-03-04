extends Area2D

@export var leads_to : int  #The level that this leads to
@export var leads_to_entrance : int = 0

func _on_body_entered(body):
	if body is Player:
		get_parent().get_parent().start_level(leads_to, leads_to_entrance)
		
	
