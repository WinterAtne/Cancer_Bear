extends CanvasLayer

func _ready() -> void:
	PlayerData.player_instance.hitbox.hit.connect(adjust_health.bind())
	PlayerData.player_instance.hitbox.healed.connect(set_health.bind())
	PlayerData.player_instance.spell_caster.aberration_changed.connect(adjust_aberration.bind())
	

func adjust_health(_damage_profile : DamageProfile, health : int, _normal : Vector2) -> void:
	$VBoxContainer/HBoxContainer/HealthBar.value = health
	

func set_health(health : int) -> void:
	$VBoxContainer/HBoxContainer/HealthBar.value = health
	

func adjust_aberration(amount : float, total : float) -> void:
	$VBoxContainer/HBoxContainer/AberrationBar.value = total
	
