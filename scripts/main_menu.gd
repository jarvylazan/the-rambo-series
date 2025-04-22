extends Control


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/forest_level_2.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_en_button_pressed() -> void:
	TranslationServer.set_locale("en")


func _on_fr_button_pressed() -> void:
	TranslationServer.set_locale("fr")


func _on_settings_button_pressed() -> void:
	%ButtonsMenu.visible = false
	%SettingsMenu.visible = true


func _on_label_pressed() -> void:
	%ButtonsMenu.visible = true
	%SettingsMenu.visible = false
