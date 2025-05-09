extends Control






func _on_level_one_button_pressed() -> void:
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn",{
		"speed": 5,
		"pattern": "scribbles",
		
	})
	

func _on_back_button_pressed() -> void:
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
	


func _on_level_two_button_pressed() -> void:
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/desert_level_2.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	


func _on_level_three_button_pressed() -> void:
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/Labyrinth_Level3.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	

func _on_level_four_button_pressed() -> void:
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/dungeon_Level_4.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})
	
