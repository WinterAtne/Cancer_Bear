extends Area2D
class_name Grab

func _ready() -> void:
	global_position = (get_viewport().get_mouse_position() 
			+ PlayerData.player_instance.camera.global_position
			- (get_viewport_rect().size / 2))
	

func _physics_process(delta) -> void:
	position = (get_viewport().get_mouse_position() 
		+ PlayerData.player_instance.camera.global_position
		- (get_viewport_rect().size / 2))
	
