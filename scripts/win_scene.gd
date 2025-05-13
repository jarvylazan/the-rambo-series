extends Node2D

@export var dialogue_scene: PackedScene = preload("res://scenes/tutorial_dialogue_box_ui.tscn")

var final_dialogue := {
	"en": [
		"Congratulations, adventurer.",
		"You have proven your courage and determination.",
		"Your name will never be forgotten among the stars.",
		"This world tested your mind, your strength, and your soul.",
		"Many have tried... all have fallen.",
		"But you stood tall in the face of darkness.",
		"You uncovered secrets buried deep in cursed stone.",
		"You fought not only beasts... but fate itself.",
		"I, Merlin, leave this gift to the bravest.",
		"Let it guide you to realms yet unseen...",
		"And may your legend echo through all worlds."
	],
	"fr": [
		"Félicitations, aventurier.",
		"Tu as prouvé ton courage et ta détermination.",
		"Ton nom ne sera jamais oublié parmi les étoiles.",
		"Ce monde a mis ton esprit, ta force et ton âme à l’épreuve.",
		"Beaucoup ont essayé... tous ont échoué.",
		"Mais tu as tenu bon face aux ténèbres.",
		"Tu as révélé des secrets enfouis dans la pierre maudite.",
		"Tu n’as pas seulement combattu des monstres... mais aussi le destin.",
		"Moi, Merlin, laisse ce présent aux plus braves.",
		"Qu’il te guide vers des royaumes encore inconnus...",
		"Et que ta légende résonne à travers tous les mondes."
	]
}

func _ready():
	Global.pause_menu = $PauseMenu

	await get_tree().create_timer(0.5).timeout
	await show_ending_dialogue()

	# Optional pause before transitioning to main menu
	await get_tree().create_timer(2.0).timeout

	await SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"pattern": "fade",
		"speed": 2.0,
		"wait_time": 0.4,
		"color": Color.BLACK,
	})

func show_ending_dialogue() -> void:
	var box = dialogue_scene.instantiate()
	get_tree().root.add_child(box)

	var lang = TranslationServer.get_locale()
	var lines = final_dialogue.get(lang, final_dialogue["en"])

	for msg in lines:
		box.queue_text(msg)

	box.show_dialogue_box()
	await box.display_text_all()
	await box.dialogue_finished
	box.queue_free()
