extends Control

@onready var background = $BackGround
@onready var audio_player = $Narration_Audio
@onready var subtitles_label = $Subtitle_Panel/Subtitles_Label
@onready var skipping_button = $Subtitle_Panel/Skipping_Button

var language = "en"
var current_index = 0

# Typewriter settings
var typing_speed = 0.32 # seconds per word
var typing_words = []
var typing_word_index = 0
var typing_timer: Timer
var full_sentence = ""

# Timeline
var timeline = [
	{
		"time": 0.0,
		"subtitle_en": "In an age where the fire of conquest burns in every heart... Where the thirst for discovery drives even the bravest to the edge of the unknown... a final gift was granted.",
		"subtitle_fr": "À une époque où le feu de la conquête brûlait dans chaque cœur... où la soif de découverte poussait même les plus braves au bord de l'inconnu... un dernier cadeau fut accordé.",
		"image": preload("res://assets/image/storyteller/slide1_age_of_conquest.png")
	},
	{
		"time": 12.0,
		"subtitle_en": "I am Merlin, the last sage mage of the old realm. As my time among mortals draws to an end, I cast one final spell—not of destruction, nor of power—but of possibility.",
		"subtitle_fr": "Je suis Merlin, le dernier mage-sage du vieux royaume. Alors que mon temps parmi les mortels touche à sa fin, je lance un dernier sort — non pas de destruction, ni de pouvoir — mais de possibilité.",
		"image": preload("res://assets/image/storyteller/slide2_merlins_spell.png")
	},
	{
		"time": 28.0,
		"subtitle_en": "With my last breath, I tore through the fabric of space and time to create something wondrous... Worlds. Endless worlds.",
		"subtitle_fr": "Dans mon dernier souffle, j'ai déchiré le tissu de l'espace et du temps pour créer quelque chose de merveilleux... Des mondes. Des mondes sans fin.",
		"image": preload("res://assets/image/storyteller/slide3_creation_of_worlds.png")
	},
	{
		"time": 37.0,
		"subtitle_en": "Each crafted with care—some lush with life, others cloaked in danger, many hiding ancient secrets long lost to time.",
		"subtitle_fr": "Chacun façonné avec soin — certains luxuriants de vie, d'autres voilés de danger, beaucoup cachant des secrets anciens oubliés du temps.",
		"image": preload("res://assets/image/storyteller/slide3_creation_of_worlds_v2.png")
	},
	{
		"time": 42.0,
		"subtitle_en": "Some you may stumble upon easily… others lie hidden, sealed away, waiting for those bold enough to find them.",
		"subtitle_fr": "Certains que vous découvrirez aisément… d'autres cachés, scellés, attendant ceux assez audacieux pour les trouver.",
		"image": preload("res://assets/image/storyteller/slide3_creation_of_worlds.png") # (reuse, or generate a secret-world themed one if you want later)
	},
	{
		"time": 58.0,
		"subtitle_en": "I did this not for kings… not for glory. I did this for you—the curious, the restless, the adventurous.",
		"subtitle_fr": "Je n'ai pas fait cela pour les rois... ni pour la gloire. Je l'ai fait pour vous — les curieux, les intrépides, les aventuriers.",
		"image": preload("res://assets/image/storyteller/slide5_adventurers_depart.png")
	},
	{
		"time": 70.0,
		"subtitle_en": "These realms are now yours to explore. To conquer. To uncover.",
		"subtitle_fr": "Ces royaumes sont désormais les vôtres à explorer. À conquérir. À dévoiler.",
		"image": preload("res://assets/image/storyteller/slide5_adventurers_depart.png") # same, or create a different one later
	},
	{
		"time": 82.0,
		"subtitle_en": "Seek out treasure beyond gold, uncover truths older than magic, and write your own legend across the stars.",
		"subtitle_fr": "Cherchez des trésors au-delà de l'or, découvrez des vérités plus anciennes que la magie et écrivez votre propre légende à travers les étoiles.",
		"image": preload("res://assets/image/storyteller/slide5_adventurers_depart.png")
	},
	{
		"time": 95.0,
		"subtitle_en": "Go now. Leave behind fear, carry only courage… For the time has come… for adventure.",
		"subtitle_fr": "Partez maintenant. Laissez la peur derrière vous, emportez seulement votre courage... Car le temps est venu... pour l'aventure.",
		"image": preload("res://assets/image/storyteller/slide5_adventurers_depart.png")
	},
	{
		"time": 108.0,
		"subtitle_en": "Welcome, brave soul, to the Adventurer of All Worlds.",
		"subtitle_fr": "Bienvenue, âme courageuse, dans l'Aventurier de Tous les Mondes.",
		"image": preload("res://assets/image/storyteller/slide6_portal_awaits.png")
	},
	{
		"time": 120.0,
		"subtitle_en": "Adventure awaits beyond the portal...",
		"subtitle_fr": "L'aventure vous attend au-delà du portail...",
		"image": preload("res://assets/image/storyteller/slide6_portal_awaits.png")
	}
]


func _ready():
	if language == "en":
		audio_player.stream = preload("res://assets/sound/merlin_audio_eng/audio_Merlin_ENG.mp3")
	else:
		audio_player.stream = preload("res://assets/sound/merlin_audio_fr/audio_Merlin_FR.mp3")
	audio_player.play()

	update_slide()

	skipping_button.pressed.connect(_on_Skip_Button_Pressed)

func _process(delta):
	if current_index < timeline.size():
		var current_time = audio_player.get_playback_position()
		if current_time >= timeline[current_index]["time"]:
			update_slide()
	
	if not audio_player.is_playing() and current_index >= timeline.size():
		end_story()

func update_slide():
	if current_index >= timeline.size():
		return

	var slide_data = timeline[current_index]
	background.texture = slide_data["image"]

	full_sentence = get_current_subtitle()
	start_typewriter(full_sentence)

	current_index += 1

func get_current_subtitle() -> String:
	var slide_data = timeline[current_index]
	if language == "en":
		return slide_data["subtitle_en"]
	else:
		return slide_data["subtitle_fr"]

func start_typewriter(sentence):
	if typing_timer:
		typing_timer.queue_free()

	typing_words = sentence.split(" ")
	typing_word_index = 0
	subtitles_label.text = ""

	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	add_child(typing_timer)
	typing_timer.timeout.connect(_on_Typing_Timer_Timeout)
	typing_timer.start()

func _on_Typing_Timer_Timeout():
	if typing_word_index < typing_words.size():
		# Instead of REPLACING text, we ADD the word
		subtitles_label.text += typing_words[typing_word_index] + " "
		typing_word_index += 1
	else:
		typing_timer.stop()
		typing_timer.queue_free()

func _on_Skip_Button_Pressed():
	end_story()

func end_story():
	get_tree().change_scene_to_file("res://scenes/tutorial_level_1.tscn")
