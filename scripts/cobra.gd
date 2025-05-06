extends Enemy

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	speed = 150
	max_health = 30
	health = max_health
	damage = 8
	detection_range = 400.0
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
	
func take_spear_damage():
	take_damage(30)

func _on_fang_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
