extends Area2D

@export var trigger_once: bool = true
var already_triggered := false

# Localized messages for boss entrance clue (mysterious tone)
var messages := {
	"en": [
		"Haha... So you managed to find the trace I left behind.",
		"I never thought you'd get this far, but here you are.",
		"There is another path... a hidden way forward.",
		"If you wish to reach the next world, you must find the one who guards it.",
		"He awaits in a place where light dares not linger...",
		"A forgotten crack beneath the roots of the mountain.",
		"Step into the shadows — if you dare — and face the trial."
	],
	"fr": [
		"Haha... Tu as trouvé l’indice que j’avais soigneusement dissimulé.",
		"Je ne pensais pas que tu irais aussi loin, et pourtant te voilà.",
		"Il existe un autre chemin... une voie secrète vers l’avenir.",
		"Pour accéder au monde suivant, tu devras affronter celui qui le protège.",
		"Il t’attend là où la lumière refuse d’entrer...",
		"Une fissure oubliée, tapie sous les racines de la montagne.",
		"Pénètre dans les ténèbres — si tu l’oses — et relève l’épreuve."
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
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	var lines = messages.get(lang, messages["en"])

	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()
