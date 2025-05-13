extends CanvasLayer
signal dialogue_finished

const CHAR_READ_RATE := 0.05  # Speed per character

@onready var dialogue_text = $DialogueText
@onready var continue_button = $ContinueButton
@onready var portrait = $HBoxContainer/Portrait
@onready var auto_advance_timer = $AutoAdvanceTimer
@onready var type_sound = $TypingSound

@export var auto_advance_delay := 5.0  

var text_queue: Array[String] = []
var tween

func _ready():
	MusicManager.stop_music()

	type_sound.play()
	print("🔊 Playing sound!")  # Log to confirm it's being called

	if continue_button:
		continue_button.visible = true
		continue_button.pressed.connect(_on_continue_pressed)

	if auto_advance_timer:
		auto_advance_timer.timeout.connect(_on_continue_pressed)

	hide_dialogue_box()

	if not text_queue.is_empty():
		display_text()


func queue_text(text: String):
	text_queue.push_back(text)

func display_text():
	if text_queue.is_empty():
		hide_dialogue_box()
		emit_signal("dialogue_finished")
		return

	if type_sound:
		type_sound.stop()  #  Ensure sound from previous line is stopped

	var next_text = text_queue.pop_front()

	if dialogue_text:
		dialogue_text.text = next_text
		dialogue_text.visible_characters = 0

	show_dialogue_box()

	if tween:
		tween.kill()
	if auto_advance_timer:
		auto_advance_timer.stop()

	if type_sound:
		type_sound.play()  # 🔊 Start typewriter sound

	tween = create_tween()
	if dialogue_text:
		tween.tween_property(
			dialogue_text,
			"visible_characters",
			next_text.length(),
			next_text.length() * CHAR_READ_RATE
		)

	await tween.finished

	if type_sound:
		type_sound.stop()  # Stop when typing animation finishes
	if auto_advance_timer:
		auto_advance_timer.start(auto_advance_delay)
		
		

func _on_continue_pressed():
	if tween:
		tween.kill()

	if type_sound:
		type_sound.stop()
	if auto_advance_timer:
		auto_advance_timer.stop()

	if dialogue_text and dialogue_text.visible_characters < dialogue_text.text.length():
		dialogue_text.visible_characters = dialogue_text.text.length()
		return

	display_text()
	
func _on_skip_pressed() -> void:
	if tween:
		tween.kill()

	text_queue.clear()

	if type_sound:
		type_sound.stop()

	if auto_advance_timer:
		auto_advance_timer.stop()

	hide_dialogue_box()
	emit_signal("dialogue_finished")



func show_dialogue_box():
	self.visible = true

func hide_dialogue_box():
	self.visible = false
	if dialogue_text:
		dialogue_text.text = ""
	if type_sound:
		type_sound.stop()
		
func display_text_all() -> void:
	while not text_queue.is_empty():
		await display_text()
