extends CanvasLayer


func _ready() -> void:
	visible = false
	$OptionsPane.visible = false
	
	

func show_pause_menu():
	visible = true
	get_tree().paused = true
	
func hide_pause_menu():
	visible = false
	get_tree().paused = false
	$OptionsPane.visible = false  # hide in case it was left open
	$Panel/VBoxContainer.visible = true



func _on_resume_button_pressed() -> void:
	hide_pause_menu()


func _on_worlds_button_pressed() -> void:
	MusicManager.play_sfx()
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/levels_selection.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})

func _on_commands_button_pressed() -> void:
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	MusicManager.play_sfx()
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/main_menu.tscn",{
		"speed": 5,
		"pattern": "scribbles",
	})



	


func _on_options_button_pressed() -> void:
	$Panel/VBoxContainer.visible = false
	$OptionsPane.visible = true
