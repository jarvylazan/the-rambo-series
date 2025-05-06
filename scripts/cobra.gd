extends Enemy

func _ready():
	speed = 150
	max_health = 30
	health = max_health
	damage = 8
	detection_range = 450.0
	attack_range = 75.0
	super()


func take_gun_damage():
	take_damage(10)
	
func take_spear_damage():
	take_damage(30)

func _on_fang_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
