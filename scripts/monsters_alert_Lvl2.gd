extends Area2D

@export var trigger_once: bool = true
var already_triggered := false

# Localized messages for generic enemy area
var messages := {
	"en": [
		"You’ve stepped into a hostile area.",
		"Be cautious... monsters roam this zone and won’t hesitate to attack."
	],
	"fr": [
		"Tu es entré dans une zone dangereuse.",
		"Reste vigilant... des monstres rôdent et attaquent sans prévenir."
	]
}

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if already_triggered and trigger_once:
		return
	if not body.is_in_group("player"):
		return

	already_triggered = true
	_show_dialogue()

func _show_dialogue():
	var dialogue_box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	var lines = messages.get(lang, messages["en"])

	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
	# No freezing / unfreezing here
