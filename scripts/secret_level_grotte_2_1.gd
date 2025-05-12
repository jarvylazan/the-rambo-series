extends Node2D

var intro_dialogue_lines := {
	"en": [
		"You’ve stepped into the heart of danger... the Cyclops domain.",
		"Even with only one eye, this creature possesses the strength of a true giant.",
		"Do not underestimate him... his gaze is sharp, and his senses sharper still.",
		"He can spot movement with terrifying speed. Staying still is not always safety.",
		"Use the environment. Find cover behind walls...",
		"Wait for your moment… strike only when it’s safe.",
		"Prepare yourself, adventurer. This is no ordinary battle... it’s a test of wit and courage.",
		"Defeat him, and the path forward will finally open."
	],
	"fr": [
		"Tu es entré dans le cœur du danger... le domaine du Cyclope.",
		"Malgré son œil unique, cette créature possède la force d’un véritable géant.",
		"Ne le sous-estime pas... son regard est perçant, et ses sens le sont encore plus.",
		"Il détecte le moindre mouvement avec une vitesse terrifiante. Rester immobile ne garantit rien.",
		"Utilise le décor. Trouve refuge derrière les murs...",
		"Attends le bon moment… frappe seulement lorsque c’est sûr.",
		"Prépare-toi, aventurier. Ce combat n’est pas ordinaire... c’est une épreuve d’esprit et de courage.",
		"Vaincs-le, et le chemin s’ouvrira enfin."
	]
}

var dialogue_box

func _ready():
	Global.pause_menu = $PauseMenu

	# Setup camera
	var player = $Player
	var camera = player.get_node("Camera2D")
	camera.zoom = Vector2(1.2, 1.2)
	camera.limit_left = 15
	camera.limit_top = 15
	camera.limit_right = 1156
	camera.limit_bottom = 660
	camera.make_current()

	# Freeze player during intro
	player.can_move = false

	# Wait a moment before showing intro dialogue
	await get_tree().create_timer(0.5).timeout
	_show_intro_dialogue()

func _show_intro_dialogue():
	dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	# When the dialogue finishes, unfreeze the player
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

	var lang = TranslationServer.get_locale()
	var lines = intro_dialogue_lines.get(lang, intro_dialogue_lines.get("en", []))
	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()

func _on_dialogue_finished():
	$Player.can_move = true
