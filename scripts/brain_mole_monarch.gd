extends Enemy

func _ready():
	speed = 200
	max_health = 60
	health = max_health
	damage = 45
	detection_range = 450.0
	attack_range = 100.0
	super()


func take_spear_damage():
	take_damage(Global.get_spear_damage())

func take_gun_damage():
	take_damage(Global.get_gun_damage())

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
