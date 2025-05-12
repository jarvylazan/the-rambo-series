extends Enemy
# BOSS LEVEL 2

func _ready():
	speed = 120
	max_health = 900
	health = max_health
	damage = 70
	detection_range = 700.0
	attack_range = 350.0
	super()
	
	drop_dialogue_lines = {
	"en": [
		"Victory, Adventurer!",
		"You’ve defeated the Cyclops... the tyrant who turned this desert into his domain.",
		"He was not born of this world, but corrupted it with brute strength and blind rage.",
		"Yet you stood tall... and crushed his reign.",
		"A golden key drops at your feet... it will open the next sealed gate.",
		"Your journey doesn't end here... greater worlds and foes await.",
		"Continue on... only glory lies ahead.",
		"My friend... this is how your legend was born."
	],

	"fr": [
		"Victoire, Aventurier !",
		"Tu as vaincu le Cyclope...le tyran qui avait transformé ce désert en son domaine.",
		"Il n’était pas né de ce monde, mais l’a corrompu par sa force brute et sa fureur aveugle.",
		"Et pourtant tu as tenu bon... et brisé son règne.",
		"Une clé dorée tombe à tes pieds... elle ouvrira la prochaine porte scellée.",
		"Ton voyage ne s’arrête pas ici... d’autres mondes et ennemis t’attendent.",
		"Poursuis ta route... seule la gloire t’attend désormais.",
		"Mon ami... c’est ainsi que ta légende est née."
	]
}


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
