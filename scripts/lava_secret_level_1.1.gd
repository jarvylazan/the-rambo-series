extends Node2D

var intro_dialogue_lines := {
	"en": [
		"Congratulations, adventurer! You've found the first of many secret paths hidden throughout your journey.",
		"This place was once part of Merlin's garden, now twisted by greed.",
		"A selfish dwarf stole this treasure and sealed it here, far from prying eyes.",
		"He is too powerful for your current strength...",
		"But worry not... use the blue potion to boost your attack for 10 seconds!",
		"You also have ammunition now. Press SPACE to shoot with your gun.",
		"Be careful: your ammo is limited. Use it wisely!"
	]
}

func _ready():
	Global.pause_menu = $PauseMenu
	# Setup camera
	var player = $Player
	var camera = player.get_node("Camera2D")
	camera.zoom = Vector2(0.9, 0.9)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 1154
	camera.limit_bottom = 665
	camera.make_current()

	# Wait a moment before showing intro dialogue
	await get_tree().create_timer(0.5).timeout
	_show_intro_dialogue()

func _show_intro_dialogue():
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	var lines = intro_dialogue_lines.get(lang, intro_dialogue_lines.get("en", []))
	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
