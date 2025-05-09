extends Node2D

var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")

# Intro dialogue lines
var intro_dialogue_lines := [
	"Hello adventurer… I'm Merlin's remaining soul.",
	"I will be your guide in this adventure.",
	"Before starting your journey, learn your ability and the possibility of these worlds I created.",
	"Use the arrow keys or 'w', 's', 'd', 'a' to move and master your environment."
]

var dialogue_box  # Store reference for later use

func _ready():
	Global.pause_menu = $PauseMenu
	MusicManager.stop_music()

	# Create and add the DialogueBox UI to the root
	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(dialogue_box)

	# Connect signal to resume gameplay when dialogue ends
	dialogue_box.dialogue_finished.connect(_on_intro_finished)

	# Setup player camera
	var player = $Player
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.position = Vector2.ZERO
	camera.make_current()
	camera.zoom = Vector2(1 , 1)  # Zoomed-out view (more of the map)

	# Camera limits based on your markers + padding
	camera.limit_left = -130
	camera.limit_top =  -139
	camera.limit_right =  1326
	camera.limit_bottom = 774

	# Disable player movement during intro
	player.can_move = false

	# Start intro after short delay
	await get_tree().create_timer(0.5).timeout

	# Queue and display dialogue
	for line in intro_dialogue_lines:
		dialogue_box.queue_text(line)

	dialogue_box.show_dialogue_box()
	await dialogue_box.display_text()

func _on_intro_finished():
	print("✅ Dialogue finished signal received!")
	$Player.can_move = true
