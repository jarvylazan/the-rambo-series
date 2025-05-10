extends Area2D

@export var next_scene_path := "res://scenes/secret_room.tscn"

var has_triggered := false

var messages := {
	"en": [
		"Hmm... something feels off here.",
		"That wall... is it solid?",
		"Try walking through it. Merlin left us hidden paths for the worthy."
	],
	"fr": [
		"Hmm... quelque chose semble étrange ici.",
		"Ce mur... est-il vraiment solide ?",
		"Essaie de passer à travers. Merlin a laissé des chemins secrets pour les dignes."
	]
}

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if has_triggered or not body.is_in_group("player"):
		return

	has_triggered = true
	body.can_move = false  # Optional: freeze player
	
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	for msg in messages.get(lang, messages["en"]):
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	get_tree().change_scene_to_file(next_scene_path)
