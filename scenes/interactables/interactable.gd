extends Area2D
class_name Interactable

var is_interactable : bool = false
var is_interacting : bool = false
var should_interact : bool = false

func _process(_delta) -> void:
	is_interacting = Input.is_action_pressed("interact")
	should_interact = is_interacting and is_interactable
	if should_interact:
		_do_interaction()
		
	

#This is a virtual function
func _do_interaction() -> void:
	pass

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		is_interactable = true
		
	

func _on_body_exited(body):
	if body is Player:
		is_interactable = false
		
	
