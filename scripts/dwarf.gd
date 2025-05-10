extends Enemy

func _ready():
	speed = 150
	max_health = 300
	health = max_health
	damage = 25
	detection_range = 300
	attack_range = 60.0
	super()


func take_gun_damage():
	take_damage(10)
	
func take_spear_damage():
	take_damage(30)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
