extends Node2D

var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")

func _ready():
	MusicManager.stop_music()

	var box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(box)

	var player = $Player
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.position = Vector2.ZERO
	camera.make_current()

	# Zoom level
	camera.zoom = Vector2(1.2, 1.2)  # Zoom in; use (1.25, 1.25) to zoom out instead

	# Camera limits
	camera.limit_left = -2734
	camera.limit_top = 227
	camera.limit_right = 6683
	camera.limit_bottom = 3750
