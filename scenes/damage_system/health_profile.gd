extends Resource
class_name Health_Profile

@export var max_health : float = 1
@export var invulnerable_seconds : float = -1 #If set to -1 the attached object does not have i-frames
@export var velocity_damage_threshold : float = 700 #If set to -1 the object does not take fall damage
