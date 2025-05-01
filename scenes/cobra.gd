extends Enemy

func _ready():
	speed = 40
	max_health = 30
	health = max_health
	damage = 8
	$AnimatedSprite2D.play("idle")
