extends Area2D

var intro_lines := {
	"en": [
		"You have entered the domain of the beast... now accept the challenge.",
		"Long ago, the Minotaur ruled these halls — a creature born of rage and bound to darkness.",
		"His prison became his throne, and now... it is your battleground."
	],
	"fr": [
		"Tu es entré dans le domaine de la bête... accepte maintenant le défi.",
		"Il y a longtemps, le Minotaure régnait sur ces couloirs — une créature née de la rage et liée aux ténèbres.",
		"Sa prison est devenue son trône... et aujourd’hui, c’est ton champ de bataille."
	]
}

var quest_lines := {
	"en": ["QUEST: BATTLE and WIN against the Minotaur!"],
	"fr": ["QUÊTE : COMBATS et VAINCS le Minotaure !"]
}

var triggered := false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if triggered or not body.is_in_group("player"):
		return

	triggered = true

	# Freeze the player
	body.can_move = false

	show_intro_dialogue(body)

func show_intro_dialogue(player: Node2D):
	var box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(box)

	var lang = TranslationServer.get_locale()
	var lines = intro_lines.get(lang, intro_lines["en"])
	for msg in lines:
		box.queue_text(msg)

	box.dialogue_finished.connect(func ():
		player.can_move = true  # Unfreeze after first dialogue
		_on_intro_done()
	)
	box.show_dialogue_box()
	box.display_text()

func _on_intro_done():
	await get_tree().create_timer(0.5).timeout
	show_quest_dialogue()

func show_quest_dialogue():
	var quest_box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(quest_box)

	var lang = TranslationServer.get_locale()
	var lines = quest_lines.get(lang, quest_lines["en"])
	for msg in lines:
		quest_box.queue_text(msg)

	quest_box.show_dialogue_box()
	quest_box.display_text()
