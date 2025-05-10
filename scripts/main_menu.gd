extends Control

func _ready() -> void:
	MusicManager.play_music()

func _on_play_button_pressed() -> void:
	MusicManager.stop_music()
	SceneManager.change_scene("res://scenes/storyteller_scene.tscn", {
		"speed": 5,
		"pattern": "scribbles",
		"language": TranslationServer.get_locale()
	})

func _on_settings_button_pressed() -> void:
	%ButtonsMenu.visible = false
	%TitleContainer.visible = false
	$OptionsPane.visible = true
	MusicManager.play_sfx()

func _on_level_buttons_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels_selection.tscn", {
		"speed": 5,
		"pattern": "scribbles"
	})
	MusicManager.play_sfx()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
