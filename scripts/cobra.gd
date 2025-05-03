extends Enemy

func _ready():
	speed = 40
	max_health = 30
	health = max_health
	damage = 8
	$AnimatedSprite2D.play("idle")

func take_gun_damage():
	take_damage(10)

func take_spear_damage():
	take_damage(30)
