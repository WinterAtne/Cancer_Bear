extends Area2D


#This is a virtual function
func _interact(body : Node2D) -> void:
	if not body is Player:
		return
	
	print(body)
	
