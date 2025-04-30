extends Control




func _on_level_one_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	%SFX.play()

func _on_back_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
	%SFX.play()


func _on_level_two_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/forest_level_2.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	%SFX.play()


func _on_level_three_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/Labyrinth_Level3.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	%SFX.play()

func _on_level_four_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/dungeon_Level_4.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	%SFX.play()
