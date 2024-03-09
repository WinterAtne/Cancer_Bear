extends Interactable

@export var spell : Spell

func _ready() -> void:
	await get_tree().process_frame
	var parent : Sprite2D = get_parent()
	
	parent.texture = spell.icon
	

func _do_interaction() -> void:
	PlayerData.player_instance.spell_caster.set_spell(spell.slot_num, spell)
	get_parent().queue_free()
	
