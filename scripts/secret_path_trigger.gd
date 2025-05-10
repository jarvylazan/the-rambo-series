extends Area2D

@export var target_scene_path: String = "res://scenes/lava_secret_level_1.1.tscn"
@export var messages := {
	"en": [
		"You feel a strange pull near the wall...",
		"A hidden path reveals itself!",
		"Prepare yourself... you're entering a forbidden zone."
	],
	"fr": [
		"Tu ressens une force étrange près du mur...",
		"Un chemin caché se révèle !",
		"Prépare-toi... tu entres dans une zone interdite."
	]
}

var dialogue_box

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	# Only trigger once
	disconnect("body_entered", Callable(self, "_on_body_entered"))

	# Freeze player
	if "can_move" in body:
		body.can_move = false

	# Show dialogue
	dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	for msg in messages.get(lang, messages["en"]):
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished.bind(body))

func _on_dialogue_finished(body):
	if "can_move" in body:
		body.can_move = true

	get_tree().change_scene_to_file(target_scene_path)
