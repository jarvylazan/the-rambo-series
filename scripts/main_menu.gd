extends Control


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/forest_level_2.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
