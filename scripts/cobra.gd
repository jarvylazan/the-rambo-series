extends Enemy

func _ready():
	speed = 150
	max_health = 60
	health = max_health
	damage = 8
	detection_range = 450.0
	attack_range = 75.0
	super()


func take_gun_damage():
	take_damage(Global.get_gun_damage())

func take_spear_damage():
	take_damage(Global.get_spear_damage())


func _on_fang_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
