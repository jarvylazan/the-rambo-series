extends Area2D

@export var target_scene_path: String = "res://scenes/secret_level_grotte_2_1.tscn"

@export var messages := {
	"en": [
		"You feel an unsettling presence nearby...",
		"The air thickensthis... is the domain of something ancient.",
		"Brace yourself... the trial begins now."
	],
	"fr": [
		"Tu ressens une présence inquiétante...",
		"L'air devient plus lourd... c'est le domaine d'une créature ancienne.",
		"Prépare-toi... l'épreuve commence maintenant."
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

	# Optional: freeze player to prevent walking during dialogue
	if "can_move" in body:
		body.can_move = false

	# Show dialogue box
	dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	for msg in messages.get(lang, messages["en"]):
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished.bind(body))

func _on_dialogue_finished(body):
	# Optional: unfreeze player, though scene is changing anyway
	if "can_move" in body:
		body.can_move = true

	get_tree().change_scene_to_file(target_scene_path)
