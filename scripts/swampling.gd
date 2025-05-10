extends Enemy

func _ready():
	speed = 150
	max_health = 100
	health = max_health
	damage = 8
	detection_range = 450.0
	attack_range = 60.0
	super()
	
	drop_dialogue_lines = {
	"en": [
		"Enemies sometimes drop items when defeated... potions, ammo, even rare or unique treasures.",
		"I greet you, adventurer, with a gift of mine...",
		"A spatial vault... an enchanted place to store whatever you gather.",
		"You may open this inventory anytime with 'E'.",
		"Items can be rearranged freely... just drag them to new slots.",
		"To drop an item: click on it, then press 'Drop', or use right-click.",
		"To use an item: only colored ones can be consumed to grant powers.",
		"Red potions restore 10% of your health... use them wisely.",
		"May this gift serve you well on your journey..."
	],
	"fr": [
		"Les ennemis laissent parfois tomber des objets : potions, munitions ou trésors rares ou uniques.",
		"Je t’offre, aventurier, un cadeau...",
		"Un coffre spatial... un lieu enchanté pour ranger tout ce que tu trouves.",
		"Tu peux ouvrir ton inventaire à tout moment avec la touche 'E'.",
		"Les objets peuvent être déplacés librement... glisse-les dans d'autres emplacements.",
		"Pour jeter un objet : clique dessus, puis sur 'Jeter', ou fais un clic droit.",
		"Pour utiliser un objet : seuls ceux en couleur peuvent être consommés.",
		"Les potions rouges restaurent 10 % de ta santé... utilise-les avec sagesse.",
		"Que ce présent t’aide dans ton aventure."
	]
}


func take_gun_damage():
	take_damage(10)
	
func take_spear_damage():
	take_damage(30)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
