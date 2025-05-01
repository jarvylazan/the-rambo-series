extends Control





func _on_restart_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn", {
		"speed": 5,
		"pattern": "scribbles",
		"language": TranslationServer.get_locale() 
	})
	MusicManager.play_sfx()


func _on_menu_button_pressed() -> void:
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"speed": 5,
		"pattern": "scribbles",
		"language": TranslationServer.get_locale() 
	})
