extends Node2D

var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")

# Desert level lore dialogue
var world_intro_dialogue_lines := {
	"en": [
		"You’ve taken your first steps, adventurer... now the true journey begins.",
		"This desert is one of the many worlds I forged... once empty, now claimed by corrupted beasts.",
		"The creatures here twisted this realm into their domain.",
		"It breathes with danger and mystery. Watch the sand… it hides more than dust.",
		"Explore the ruins, uncover the truth, and conquer what lies ahead.",
		"Fifteen enemies await you—each a challenge of its own.",
		"Eliminate them all… and face the one who commands this scorched world.",
		"This is your first true trial. Let it be a beginning, not an end."
	],

	"fr": [
		"Tu as fait tes premiers pas, aventurier... maintenant commence le vrai voyage.",
		"Ce désert est l’un des mondes que j’ai créés... autrefois vide, désormais déformé par des bêtes corrompues.",
		"Ces créatures ont fait de ce royaume leur domaine.",
		"Il respire le danger et le mystère. Attention au sable... il cache plus que de la poussière.",
		"Explore les ruines, découvre la vérité, et conquiers ce qui t’attend.",
		"Quinze ennemis t’attendent—chacun avec ses propres défis.",
		"Élimine-les tous… et affronte celui qui commande ce monde brûlé.",
		"Voici ta première véritable épreuve. Qu’elle soit un commencement, et non une fin."
	]
}

var dialogue_box  # Dialogue box instance

func _ready():
	Global.pause_menu = $PauseMenu
	MusicManager.stop_music()

	# Instantiate and add dialogue box
	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(dialogue_box)

	# Connect signal
	dialogue_box.dialogue_finished.connect(_on_intro_finished)

	# Set up camera
	var player = $Player
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.position = Vector2.ZERO
	camera.make_current()
	camera.zoom = Vector2(0.85, 0.85)
	camera.limit_left = -2734
	camera.limit_top = 227
	camera.limit_right = 6683
	camera.limit_bottom = 3750

	# Lock player
	player.can_move = false

	# Start dialogue
	await get_tree().create_timer(2.5).timeout

	var language = TranslationServer.get_locale()
	for line in world_intro_dialogue_lines.get(language, world_intro_dialogue_lines["en"]):
		dialogue_box.queue_text(line)

	dialogue_box.show_dialogue_box()
	await dialogue_box.display_text()

func _on_intro_finished():
	print("Dialogue finished signal received!")
	$Player.can_move = true
