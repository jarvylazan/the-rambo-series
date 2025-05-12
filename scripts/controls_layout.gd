extends Control


func _on_pause_menu_button_pressed() -> void:
	get_parent().get_node("Panel/VBoxContainer").visible = true
	visible = false
