extends Control

@onready var level_died: Label = $CanvasLayer/VBoxContainer/HBoxContainer/WorldNumberLabel
@onready var coin_collected: Label = $CanvasLayer/VBoxContainer/HBoxContainer2/NumberOfCoinsLabel

func _ready() -> void:
	Global.heal(100)
	
	level_died.text = str(Global.level_tracker)
	
	coin_collected.text = str(Global.coin_count)


func _on_restart_button_pressed() -> void:
	if Global.level_tracker == 1:
		SceneManager.change_scene("res://scenes/tutorial_level_1.tscn", {
			"speed": 5,
			"pattern": "scribbles",
			"language": TranslationServer.get_locale() 
		})
	elif Global.level_tracker == 2:
		SceneManager.change_scene("res://scenes/desert_level_2.tscn", {
			"speed": 5,
			"pattern": "scribbles",
			"language": TranslationServer.get_locale() 
		})
	elif Global.level_tracker == 3:
				SceneManager.change_scene("res://scenes/Labyrinth_Level3.tscn", {
			"speed": 5,
			"pattern": "scribbles",
			"language": TranslationServer.get_locale() 
		})
	elif Global.level_tracker == 4:
		SceneManager.change_scene("res://scenes/dungeon_Level_4.tscn", {
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
