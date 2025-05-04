extends Enemy

func _ready():
	speed = 40
	max_health = 30
	health = max_health
	damage = 8
	detection_range = 120.0
	attack_range = 35.0
	super()
	
func attack() -> void:
	if is_attacking or is_dead or not can_attack:
		return

	is_attacking = true
	can_attack = false
	anim_player.play("attack")
	await anim_player.animation_finished
	is_attacking = false

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func take_gun_damage():
	take_damage(10)
