extends Interactable
class_name Edible

@export var data : EdibleData

@onready var shape : CollisionShape2D = $Shape
@onready var sprite : Sprite2D = $Sprite

func _ready():
	if not data:
		queue_free()
		
	
	shape.shape.radius = data.interaction_radius
	sprite.texture = data.texture
	sprite.rotation_degrees = -90
	

func _do_interaction():
	PlayerData.player_instance.spell_caster.give_aberration(-data.aberration)
	
	is_interactable = false
	queue_free.call_deferred()
	
