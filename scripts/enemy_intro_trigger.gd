extends Area2D

@export var trigger_once: bool = true
@export var enemy_path: NodePath

var already_triggered := false
var player_ref: Node = null

# Localized messages from Merlin
var messages := {
	"en": [
		"Brave adventurer, you face your first true challenge...",
		"These are the Thornlings... Once guardians of Merlin's Forgotten Garden.",
		"Twisted by time and magic, they now attack anything that enters their domain.",
		"They're small... but underestimate them and you'll pay the price.",
		"Press 'V' to strike with your spear and deal 30 damage."
	],
	"fr": [
		"Vaillant aventurier, tu affrontes ton premier vrai défi...",
		"Voici les Ronces... jadis gardiens du Jardin Oublié de Merlin.",
		"Dénaturés par le temps et la magie, ils attaquent tout intrus.",
		"Ils sont petits... mais les sous-estimer serait une grave erreur.",
		"Appuie sur 'V' pour frapper avec ta lance et infliger 30 dégâts."
	]
}

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if already_triggered and trigger_once:
		return
	if not body.is_in_group("player"):
		print("🚫 Not the player:", body.name)
		return

	print("✅ Player entered trigger zone!")
	already_triggered = true
	player_ref = body

	# Freeze player movement if possible
	if "can_move" in player_ref:
		print("🔒 Freezing player")
		player_ref.can_move = false

	_show_dialogue()

func _show_dialogue():
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	var lines = messages.get(lang, messages["en"])

	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	if player_ref and "can_move" in player_ref:
		print("✅ Unfreezing player")
		player_ref.can_move = true

		# Optional: force idle animation so the player doesn't slide weirdly
		if "play_idle_animation" in player_ref:
			player_ref.play_idle_animation()
