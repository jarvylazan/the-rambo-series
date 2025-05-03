extends Enemy

func _ready():
	speed = 40
	max_health = 30
	health = max_health
	damage = 8
	detection_range = 120.0
	attack_range = 35.0
	super()

func take_gun_damage():
	take_damage(10)
