extends Node2D

var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")

func _ready():
	MusicManager.stop_music()
	var box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(box)

	
