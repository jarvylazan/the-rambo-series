extends Node2D

var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")

# Intro dialogue lines
var intro_dialogue_lines := [
	"Hello adventurer… I'm Merlin's remaining soul.",
	"I will be your guide in this adventure.",
	"Before starting your journey, learn your ability and the possibility of these worlds I created.",
	"Use the arrow keys  or 'w', 's','d','a', to move and master your environment."
]

var dialogue_box  # Store reference for later use

func _ready():
	MusicManager.stop_music()

	# Instantiate and add the DialogueBox UI
	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(dialogue_box)

	# Connect signal to re-enable player movement when done
	dialogue_box.dialogue_finished.connect(_on_intro_finished)

	# Set camera as child of player
	var player = $Player
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.position = Vector2.ZERO
	camera.make_current()

	# Zoom level
	camera.zoom = Vector2(1.2, 1.2)  # Zoom in

	# Camera limits
	camera.limit_left = -2734
	camera.limit_top = 227
	camera.limit_right = 6683
	camera.limit_bottom = 3750

	# Disable movement during intro
	player.can_move = false

	# Start tutorial intro dialogue after short delay
	await get_tree().create_timer(0.5).timeout

	for line in intro_dialogue_lines:
		dialogue_box.queue_text(line)

	dialogue_box.show_dialogue_box()
	await dialogue_box.display_text()  # Optional: can rely only on signal

func _on_intro_finished():
	print("✅ Dialogue finished signal received!")
	$Player.can_move = true
