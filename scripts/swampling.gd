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
		"May this gift serve you well on your journey...",
		"Remember, adventurer: secrets shown to all are often the hardest to see...",
		"Hidden realms twist around the unknown, waiting quietly behind doors... portals... or walls",
		"Haha... I almost said too much. My time passed long ago... this journey is yours now.",
		"Your next quest is to uncover the hidden path within this place..."
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
		"Que ce présent t’aide dans ton aventure...",
		"Souviens-toi, aventurier : les secrets visibles de tous sont souvent les plus difficiles à percevoir...",
		"Des royaumes cachés gravitent autour de l’inconnu, tapis derrière des portes... des portails... ou des murs",
		"Haha... J’ai failli tout révéler. Mon temps est révolu... cette aventure est désormais la tienne.",
		"Ta prochaine quête est de découvrir le chemin caché en ces lieux..."
	]
}

func take_spear_damage():
	take_damage(Global.get_spear_damage())

func take_gun_damage():
	take_damage(Global.get_gun_damage())

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.take_damage(10)
