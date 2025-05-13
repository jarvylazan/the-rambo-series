extends Area2D

@export var dialogue_scene: PackedScene = preload("res://scenes/dialogue_main_game.tscn")

var already_triggered := false

# Dialogue lines
var warning_dialogue_lines := {
	"en": [
		"In this map, many traps were placed...",
		"From poison to falling in the abyss...",
		"Stay sharp, adventurer."
	],
	"fr": [
		"Dans cette carte, de nombreux pièges ont été placés...",
		"Du poison jusqu’à la chute dans l’abîme...",
		"Reste sur tes gardes, aventurier."
	]
}

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	if already_triggered:
		return
	if not body.is_in_group("player"):
		return

	already_triggered = true
	await show_warning_dialogue(body)

func show_warning_dialogue(player: Node2D):
	if "can_move" in player:
		player.can_move = false

	var dialogue = dialogue_scene.instantiate()
	get_tree().root.add_child(dialogue)

	var lang = TranslationServer.get_locale()
	var lines = warning_dialogue_lines.get(lang, warning_dialogue_lines["en"])

	for line in lines:
		dialogue.queue_text(line)

	dialogue.show_dialogue_box()
	await dialogue.display_text()

	if "can_move" in player:
		player.can_move = true
