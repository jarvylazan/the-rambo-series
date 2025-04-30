extends Control


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_en_button_pressed() -> void:
	TranslationServer.set_locale("en")


func _on_fr_button_pressed() -> void:
	TranslationServer.set_locale("fr")


func _on_settings_button_pressed() -> void:
	%ButtonsMenu.visible = false
	%OptionsPane.visible = true
	%TitleContainer.visible = false

func _on_save_button_pressed() -> void:
	%ButtonsMenu.visible = true
	%OptionsPane.visible = false
	%TitleContainer.visible = true


func _on_level_buttons_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels_selection.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
