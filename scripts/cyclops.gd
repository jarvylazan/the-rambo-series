extends Enemy
# BOSS LEVEL 2

func _ready():
	speed = 150
	max_health = 30
	health = max_health
	damage = 8
	detection_range = 700.0
	attack_range = 350.0
	super()
	
func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var to_player = player.global_position - global_position
	var dist_to_player = to_player.length()
	var is_same_y_band = abs(to_player.y) < 100
	var flip_left = to_player.x < 0

	if dist_to_player <= attack_range:
		if is_same_y_band:
			velocity = Vector2.ZERO
			attack(flip_left)
		else:
			move_towards(player.global_position)  # Chase to align vertically
	elif dist_to_player <= detection_range:
		move_towards(player.global_position)
	else:
		patrol()

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO

	update_animation(velocity)


func attack(flip_left: bool) -> void:
	# Only attack if player is roughly in the same Y-level (± threshold)
	if player and abs(player.global_position.y - global_position.y) < 100:
		super.attack(flip_left)  # Call the Enemy version
	# Else: do nothing

func take_spear_damage():
	take_damage(Global.get_spear_damage())

func take_gun_damage():
	take_damage(Global.get_gun_damage())

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
