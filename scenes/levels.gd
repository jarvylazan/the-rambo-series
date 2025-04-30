extends Control




func _on_level_one_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})

func _on_back_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_level_two_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_three_button_pressed() -> void:
	pass # Replace with function body.
