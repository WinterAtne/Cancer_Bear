extends Area2D

signal hit(damage : int)

func _on_area_entered(area):
	if area is HurtBox:
		print(area.damage)
		hit.emit(area.damage)
		
	
	
