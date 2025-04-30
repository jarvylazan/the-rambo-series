extends Control

@onready var background = $BackGround
@onready var audio_player = $Narration_Audio
@onready var subtitles_label = $Subtitle_Panel/Subtitles_Label
@onready var skipping_button = $Subtitle_Panel/Skipping_Button

var language = "en"
var current_chunk = 0
var typing_speed = 0.35
var typing_words = []
var typing_word_index = 0
var typewriter_timer: Timer

var story_chunks = [
	{
		"text": "In an age where the fire of conquest burns in every heart... where the thirst for discovery drives even the bravest to the edge of the unknown... a final gift was granted.",
		"image": preload("res://assets/image/storyteller/slide1.2_age_of_conquest.png"),
		"delay": 12.0
	},
	{
		"text": "I am Merlin, the last sage mage of the old realm. As my time among mortals draws to an end, I cast one final spell—not of destruction, nor of power... but of possibility.",
		"image": preload("res://assets/image/storyteller/slide2_merlins_spell.png"),
		"delay": 14.0
	},
	{
		"text": "With my last breath, I tore through the fabric of space and time to create something wondrous... Worlds. Endless worlds.",
		"image": preload("res://assets/image/storyteller/slide3_creation_of_worlds.png"),
		"delay": 10.0
	},
	{
		"text": "Each crafted with care—some lush with life,",
		"image": preload("res://assets/image/storyteller/slide4_new_worlds.png"),
		"delay": 3.5
	},
	{
		"text": "Others cloaked in danger, many hiding ancient secrets long lost to time.",
		"image": preload("res://assets/image/storyteller/slide4.1_danger.png"),
		"delay": 5.0
	},
	{
		"text": "Some you may stumble upon easily… others lie hidden, sealed away, waiting for those bold enough to find them.",
		"image": preload("res://assets/image/storyteller/slide4.2_hidden_place.png"),
		"delay": 8.5
	},
	{
		"text": "I did this not for kings… not for glory.
I did this for you—the curious, the restless, the adventurous.
",
		"image": preload("res://assets/image/storyteller/slide4.3_epic_battle.png"),
		"delay": 8.5
	},
	{
		"text": "These realms are now yours to explore. To conquer. To uncover.",
		"image": preload("res://assets/image/storyteller/slide5_adventurers_depart.png"),
		"delay": 5.5
	},
	{
		"text": "Seek out treasure beyond gold, uncover truths older than magic, and write your own legend across the stars. Go now. Leave behind fear, carry only courage… For the time has come… for adventure.",
		"image": preload("res://assets/image/storyteller/slide6_portal_awaits.png"),
		"delay": 17.0
	},
	
	{
		"text": "Welcome, brave soul, to the Adventurer of All Worlds. This is your time... Adventure time.",
		"image": preload("res://assets/image/storyteller/slide6.1.2_welcome_player.png"),
		"delay": 8.0
	}
]

func _ready():
	audio_player.play()
	show_chunk(current_chunk)
	skipping_button.pressed.connect(_on_Skip_Button_Pressed)

func show_chunk(index):
	if index >= story_chunks.size():
		end_story()
		return

	var chunk = story_chunks[index]
	background.texture = chunk["image"]
	subtitles_label.text = ""
	start_typewriter(chunk["text"])

	var wait_timer = Timer.new()
	wait_timer.one_shot = true
	wait_timer.wait_time = chunk.get("delay", 6.0)
	add_child(wait_timer)
	wait_timer.timeout.connect(func():
		current_chunk += 1
		show_chunk(current_chunk)
	)
	wait_timer.start()

func start_typewriter(sentence):
	if typewriter_timer:
		typewriter_timer.queue_free()

	typing_words = sentence.split(" ")
	typing_word_index = 0
	subtitles_label.text = ""

	typewriter_timer = Timer.new()
	typewriter_timer.wait_time = typing_speed
	typewriter_timer.one_shot = false
	add_child(typewriter_timer)
	typewriter_timer.timeout.connect(_on_Typing_Timer_Timeout)
	typewriter_timer.start()

func _on_Typing_Timer_Timeout():
	if typing_word_index < typing_words.size():
		subtitles_label.text += typing_words[typing_word_index] + " "
		typing_word_index += 1
	else:
		typewriter_timer.stop()
		typewriter_timer.queue_free()

func _on_Skip_Button_Pressed():
	end_story()

func end_story():
	get_tree().change_scene_to_file("res://scenes/tutorial_level_1.tscn")
