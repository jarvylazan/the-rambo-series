extends CanvasLayer

const CHAR_READ_RATE := 0.05  # Speed per character

@onready var dialogue_text = $DialogueText
@onready var continue_button = $ContinueButton
@onready var portrait = $HBoxContainer/Portrait
@onready var auto_advance_timer = $AutoAdvanceTimer
@onready var type_sound = $TypeSound

@export var auto_advance_delay := 5.0  

var text_queue: Array[String] = []
var tween

func _ready():
	MusicManager.stop_music()

	continue_button.visible = true
	continue_button.pressed.connect(_on_continue_pressed)
	auto_advance_timer.timeout.connect(_on_continue_pressed)

	hide_dialogue_box()

	# 🔸 Demo lines – remove in final version
	queue_text("Welcome, adventurer...")
	queue_text("I am Merlin, your guide.")
	queue_text("Use the arrow keys to move.")

	if not text_queue.is_empty():
		display_text()

func queue_text(text: String):
	text_queue.push_back(text)

func display_text():
	if text_queue.is_empty():
		hide_dialogue_box()
		return

	type_sound.stop()  # 🛑 Ensure sound from previous line is stopped

	var next_text = text_queue.pop_front()
	dialogue_text.text = next_text
	dialogue_text.visible_characters = 0
	show_dialogue_box()

	if tween:
		tween.kill()
	auto_advance_timer.stop()

	type_sound.play()  # 🔊 Start typewriter sound

	tween = create_tween()
	tween.tween_property(
		dialogue_text,
		"visible_characters",
		next_text.length(),
		next_text.length() * CHAR_READ_RATE
	)

	await tween.finished

	type_sound.stop()  # 🛑 Stop when typing animation finishes
	auto_advance_timer.start(auto_advance_delay)

func _on_continue_pressed():
	if tween:
		tween.kill()

	type_sound.stop()  # 🛑 Stop sound if skipping line manually
	auto_advance_timer.stop()

	# If still typing → finish instantly
	if dialogue_text.visible_characters < dialogue_text.text.length():
		dialogue_text.visible_characters = dialogue_text.text.length()
		return

	# Otherwise, advance to next line or close
	display_text()

func show_dialogue_box():
	self.visible = true

func hide_dialogue_box():
	self.visible = false
	dialogue_text.text = ""
	type_sound.stop()  # 🛑 Stop sound when box is hidden
