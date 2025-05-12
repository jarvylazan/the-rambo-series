extends Enemy

func _ready():
	speed = 150
	max_health = 1200
	health = max_health
	damage = 40
	detection_range = 400
	attack_range = 80.0
	super()

	drop_dialogue_lines = {
	"en": [
		"Congratulations, Adventurer!",
		"You’ve defeated the boss that was disturbing this realm.",
		"Your first quest is now complete... you are ready to carve your path...",
		"...and write your name among the stars.",
		"Go on, explore the vast world waiting only for you.",
		"A key has been dropped... ",
		"Among the many items dropped, one shines brighter... a yellow potion.",
		"Yellow potions restore 100% of your health. Use them wisely in dire times.",
		"Use this key to access the Gate of All Possibilities.",
		"The gate leads to new worlds...",
		"This is your ADVENTURE TIME!"
	],
	"fr": [
		"Félicitations, Aventurier !",
		"Tu as vaincu le boss qui troublait ce royaume.",
		"Ta première quête est accomplie... tu es prêt à tracer ton chemin...",
		"...et inscrire ton nom parmi les étoiles.",
		"Pars maintenant explorer le vaste monde qui n’attend que toi.",
		"Une clé est tombée... ",
		"Parmi les objets tombés, l’un brille plus que les autres : une potion jaune.",
		"Les potions jaunes restaurent 100 % de ta vie. Garde... les pour les moments critiques.",
		"Utilise-la pour franchir la Porte de Toutes les Possibilités.",
		"Cette porte mène à de nouveaux mondes...",
		"C’est ton HEURE D’AVENTURE !"
	]
}


func take_spear_damage():
	take_damage(Global.get_spear_damage())

func take_gun_damage():
	take_damage(Global.get_gun_damage())

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
