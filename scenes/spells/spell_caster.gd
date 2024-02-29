extends Node2D
class_name SpellCaster

@export var max_aberration : int = 200
var aberation : int

@export var spell_list : Array[Spell] = []

signal spell_list_changed(index : int, new_spell : Spell)
signal spell_used(spell : Spell)

func _ready():
	spell_list.resize(5)
	aberation = max_aberration
	

func set_spell(index : int, new_spell : Spell) -> void:
	if index >= 5:
		push_error("You cannot load more than five spells into the spell list")
		return
		
	
	spell_list[index] = new_spell
	spell_list_changed.emit(index, new_spell)
	

func use_spell(index : int) -> void:
	var spell : Node2D = spell_list[index].effect.instantiate()
	get_parent().get_parent().add_child(spell)
	spell.global_position = global_position
	aberation -= spell_list[index].aberration_cost
	
	spell_used.emit(spell_list[index])
	
