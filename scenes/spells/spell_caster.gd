extends Node2D
class_name SpellCaster

@export var max_aberration : float = 6
var aberration : float

@export var spell_list : Array[Spell] = []

signal spell_list_changed(index : int, new_spell : Spell)
signal spell_used(spell : Spell)
signal spell_failled(spell : Spell)
signal aberration_changed(amount : float, total : float)

func _ready() -> void:
	spell_list.resize(5)
	aberration = max_aberration
	

func set_spell(index : int, new_spell : Spell) -> void:
	if index >= 5:
		push_error("You cannot load more than five spells into the spell list")
		return
		
	
	spell_list[index] = new_spell
	spell_list_changed.emit(index, new_spell)
	

func use_spell(index : int) -> void:
	if (aberration <= 0):
		spell_failled.emit()
		return
		
	
	var spell : Node2D = spell_list[index].effect.instantiate()
	get_parent().get_parent().add_child(spell)
	spell.global_position = global_position
	give_aberration(spell_list[index].aberration_cost)
	
	spell_used.emit(spell_list[index])
	

func give_aberration(amount : float):
	aberration -= amount
	#ensure's we don't have negative or above max aberration
	if aberration > max_aberration:
		aberration = max_aberration
		
	elif aberration < 0:
		aberration = 0
		
	
	aberration_changed.emit(amount, aberration)
	
