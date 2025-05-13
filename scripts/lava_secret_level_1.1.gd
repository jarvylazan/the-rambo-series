extends Node2D

# Intro (tutorial-style) dialogue
var intro_dialogue_lines := {
	"en": [
		"Congratulations, adventurer! You've found the first of many secret paths hidden throughout your journey.",
		"This place was once part of Merlin's garden, now twisted by greed.",
		"A selfish dwarf stole this treasure and sealed it here, far from prying eyes.",
		"He is too powerful for your current strength...",
		"But worry not... use the blue potion to boost your attack for 10 seconds!",
		"You also have ammunition now. Press SPACE to shoot with your gun.",
		"Be careful: your ammo is limited. Use it wisely!"
	],
	"fr": [
		"Félicitations, aventurier ! Tu as trouvé le premier des nombreux chemins secrets cachés dans ton aventure.",
		"Cet endroit faisait autrefois partie du jardin de Merlin, maintenant déformé par la cupidité.",
		"Un nain égoïste a volé ce trésor et l’a scellé ici, loin des regards indiscrets.",
		"Il est trop puissant pour ta force actuelle...",
		"Mais ne t’inquiète pas... utilise la potion bleue pour augmenter ton attaque pendant 10 secondes !",
		"Tu as aussi des munitions maintenant. Appuie sur ESPACE pour tirer avec ton arme.",
		"Attention : tes munitions sont limitées. Utilise-les avec sagesse !"
	]
}

# Second message about goal
var boss_goal_dialogue_lines := {
	"en": ["Eliminate the boss to complete this secret challenge."],
	"fr": ["Élimine le boss pour réussir ce défi secret."]
}

var player

func _ready():
	
	Global.pause_menu = $PauseMenu
	MusicManager.stop_music()
	$BGMPlayer.play()
	player = $Player
	player.can_move = false  # ❄️ Freeze only for first dialogue

	# Setup camera
	var camera = player.get_node("Camera2D")
	camera.zoom = Vector2(0.9, 0.9)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 1154
	camera.limit_bottom = 665
	camera.make_current()

	await get_tree().create_timer(0.5).timeout
	_show_intro_dialogue()

func _show_intro_dialogue():
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	var lines = intro_dialogue_lines.get(lang, intro_dialogue_lines["en"])
	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.dialogue_finished.connect(_on_intro_finished)
	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()

func _on_intro_finished():
	player.can_move = true  # ✅ Unfreeze after first dialogue

	await get_tree().create_timer(1.0).timeout
	_show_boss_goal_dialogue()

func _show_boss_goal_dialogue():
	var second_box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(second_box)

	var lang = TranslationServer.get_locale()
	var lines = boss_goal_dialogue_lines.get(lang, boss_goal_dialogue_lines["en"])
	for msg in lines:
		second_box.queue_text(msg)

	second_box.show_dialogue_box()
	second_box.display_text()
