extends Control

@onready var bg_a = $BackGround
@onready var bg_b = $BackGround_2
@onready var story_bgm = $StoryBGM
@onready var audio_player = $Narration_Audio
@onready var subtitles_label = $CanvasLayer/SubtitlePanel/SubtitlesLabel
@onready var skipping_button = $"CanvasLayer/Button-Container/Skipping_Button"

@onready var tween := get_tree().create_tween()
# @onready var image_sfx := preload("res://assets/sound/slide_change.mp3") 

var showing_a = true
var language = "en"
var current_chunk = 0
var typing_speed = 0.35
var typing_words = []
var typing_word_index = 0
var typewriter_timer: Timer
var story_chunks = []

var story_chunks_en = [
	{
		"text": "In an age where the fire of conquest burns in every heart... where the thirst for discovery drives even the bravest to the edge of the unknown... a final gift was granted...",
		"image": preload("res://assets/image/storyteller/slide1.2_age_of_conquest.png"),
		"delay": 12.0
	},
	{
		"text": "I am Merlin, the last sage mage of the old realm. As my time among mortals draws to an end, I cast one final spell...not of destruction, nor of power... but of possibility...",
		"image": preload("res://assets/image/storyteller/slide2_merlins_spell.png"),
		"delay": 14.0
	},
	{
		"text": "With my last breath, I tore through the fabric of space and time to create something wondrous... Worlds. Endless worlds.",
		"image": preload("res://assets/image/storyteller/slide3_creation_of_worlds.png"),
		"delay": 10.0
	},
	{
		"text": "Each crafted with care...some lush with life,",
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
		"text": "I did this not for kings… not for glory.\nI did this for you...the curious, the restless, the adventurous.",
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

var story_chunks_fr = [
	{
		"text": "À une époque où le feu de la conquête brûle dans chaque cœur... où la soif de découverte pousse même les plus braves aux confins de l'inconnu... un dernier cadeau fut accordé.",
		"image": preload("res://assets/image/storyteller/slide1.2_age_of_conquest.png"),
		"delay": 12.0
	},
	{
		"text": "Je suis Merlin, le dernier mage-sage du vieux royaume. Alors que mon temps parmi les mortels touche à sa fin, j'ai lancé un ultime sort... non de destruction, ni de puissance... mais de possibilité.",
		"image": preload("res://assets/image/storyteller/slide2_merlins_spell.png"),
		"delay": 16.0
	},
	{
		"text": "Dans mon dernier souffle, j'ai modelé le tissu de l’espace-temps pour créer quelque chose de merveilleux... Des mondes. Une infinité de nouveaux mondes.",
		"image": preload("res://assets/image/storyteller/slide3_creation_of_worlds.png"),
		"delay": 10.5
	},
	{
		"text": "Chacun façonné avec soin... certains foisonnant de vie,",
		"image": preload("res://assets/image/storyteller/slide4_new_worlds.png"),
		"delay": 4.0
	},
	{
		"text": "D'autres enveloppés de danger... beaucoup dissimulant d'anciens secrets oubliés par le temps.",
		"image": preload("res://assets/image/storyteller/slide4.1_danger.png"),
		"delay": 6.0
	},
	{
		"text": "Certains vous apparaîtront aisément... d'autres resteront cachés, scellés, n'attendant que les âmes assez audacieuses pour les découvrir.",
		"image": preload("res://assets/image/storyteller/slide4.2_hidden_place.png"),
		"delay": 10.0
	},
	{
		"text": "Je n'ai pas fait cela pour des rois... ni pour la gloire.\nJe l'ai fait pour vous... les curieux, les intrépides, les aventuriers.",
		"image": preload("res://assets/image/storyteller/slide4.3_epic_battle.png"),
		"delay": 10.0
	},
	{
		"text": "Ces royaumes sont désormais vôtres. À explorer... À conquérir... À dévoiler.",
		"image": preload("res://assets/image/storyteller/slide5_adventurers_depart.png"),
		"delay": 6.0
	},
	{
		"text": "Cherchez des trésors au-delà de l'or, révélez des vérités plus anciennes que la magie, et écrivez votre propre légende parmi les étoiles. Allez maintenant... laissez derrière vous la peur, et ne portez que le courage... Car l'heure est venue... l'heure de l'aventure.",
		"image": preload("res://assets/image/storyteller/slide6_portal_awaits.png"),
		"delay": 19.0
	},
	{
		"text": "Bienvenue, âme courageuse, dans Adventurer of All Worlds. C'est votre moment... votre aventure commence dès maintenant.",
		"image": preload("res://assets/image/storyteller/slide6.1.2_welcome_player.png"),
		"delay": 10.0
	}
]


func _ready():
	MusicManager.stop_music()
	story_bgm.play()
	var scene_args = SceneManager.get_scene_args()
	language = scene_args.get("language", "en")

	load_story_chunks()
	play_narration_audio()

	show_chunk(current_chunk)
	skipping_button.pressed.connect(_on_Skip_Button_Pressed)
	
	subtitles_label.add_theme_color_override("shadow_color", Color(0, 0, 0, 0.5))
	subtitles_label.add_theme_constant_override("shadow_offset_x", 1)
	subtitles_label.add_theme_constant_override("shadow_offset_y", 1)

func load_story_chunks():
	if language == "fr":
		story_chunks = story_chunks_fr
	else:
		story_chunks = story_chunks_en

func play_narration_audio():
	var audio_path = ""
	if language == "fr":
		audio_path = "res://assets/sound/merlin_audio_fr/audio_Merlin_FR_v2.mp3"
	else:
		audio_path = "res://assets/sound/merlin_audio_eng/Audio_Merlin_Eng_v2.mp3"
	
	audio_player.stream = load(audio_path)
	audio_player.play()

func show_chunk(index):
	if index >= story_chunks.size():
		end_story()
		return

	var chunk = story_chunks[index]

	var fade_out = bg_a if showing_a else bg_b
	var fade_in = bg_b if showing_a else bg_a

	fade_in.texture = chunk["image"]
	fade_in.modulate.a = 0.0

	tween.kill()
	tween = get_tree().create_tween()

	# ✅ First fade in the new image
	tween.tween_property(fade_in, "modulate:a", 1.0, 0.4)

	# ✅ THEN fade out the old image after
	tween.tween_property(fade_out, "modulate:a", 0.0, 0.4)

	showing_a = !showing_a

	# Optional whoosh
	var whoosh = AudioStreamPlayer.new()
	# whoosh.stream = image_sfx
	whoosh.bus = "SFX_UI"
	add_child(whoosh)
	whoosh.play()
	whoosh.finished.connect(whoosh.queue_free)

	# Start typewriter
	subtitles_label.text = ""
	start_typewriter(chunk["text"])

	# Timer to go to next chunk
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

func _on_replay_button_pressed():
	# Stop narration audio
	audio_player.stop()
	MusicManager.play_sfx()
	# Safely stop and delete typewriter timer
	if typewriter_timer and typewriter_timer.is_inside_tree():
		typewriter_timer.stop()
		typewriter_timer.queue_free()

	# Safely stop and delete delay timer
	for child in get_children():
		if child is Timer and not child.is_queued_for_deletion():
			child.stop()
			child.queue_free()

	# Reset story index
	current_chunk = 0

	# Restart narration and visuals
	story_bgm.play()
	play_narration_audio()
	show_chunk(current_chunk)


func _on_back_button_pressed():
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_Skip_Button_Pressed():
	end_story()

func end_story():
	story_bgm.stop()
	MusicManager.play_sfx()
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_skipping_button_pressed() -> void:
	pass # Replace with function body.
