extends Node2D

var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")

# Intro dialogue lines
var intro_dialogue_lines := {
	"en": [
		"Hello adventurer... I'm Merlin's remaining soul.",
		"I will be your guide in this adventure.",
		"Before starting your journey, learn your ability and the possibility of these worlds I created.",
		"Use the arrow keys or 'w', 's', 'd', 'a' to move and master your environment."
	],
	"fr": [
		"Bonjour aventurier... Je suis l'âme restante de Merlin.",
		"Je serai ton guide dans cette aventure.",
		"Avant de commencer ton voyage, découvre tes capacités et les mondes que j'ai créés.",
		"Utilise les flèches ou 'w', 's', 'd', 'a' pour te déplacer et explorer ton environnement."
	]
}

var dialogue_box

func _ready():
	Global.pause_menu = $PauseMenu
	MusicManager.stop_music()
	
	Global.level_tracker = 1

	var language = TranslationServer.get_locale()

	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(dialogue_box)

	dialogue_box.dialogue_finished.connect(_on_intro_finished)

	var player = $Player
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.position = Vector2.ZERO
	camera.make_current()
	camera.zoom = Vector2(0.9, 0.9)

	# Set camera boundaries
	camera.limit_left = -130
	camera.limit_top = -139
	camera.limit_right = 1326
	camera.limit_bottom = 774

	player.can_move = false

	await get_tree().create_timer(0.5).timeout

	for line in intro_dialogue_lines.get(language, intro_dialogue_lines["en"]):
		dialogue_box.queue_text(line)

	dialogue_box.show_dialogue_box()
	await dialogue_box.display_text()

func _on_intro_finished():
	print("Dialogue finished signal received!")
	$Player.can_move = true
