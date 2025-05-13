extends Node2D
var intro_dialogue_done := false
var enemy_count := 0
var enemy_count_label  # Will properly initialize this in _ready

# Level 3 Intro Dialogue Lines (Narrative tone)
var level3_intro_lines := {
	"en": [
		"You’ve entered the third world... the heart of the labyrinth.",
		"This place was not built to welcome you, adventurer... it was carved to confuse, to test, to trap.",
		"Here, strength alone will not guide you forward.",
		"A true adventurer must be strategic, must adapt to shifting paths and unseen threats.",
		"Each corridor, each turn, was placed with intent... to challenge your instincts.",
		"Many paths await you, some twisted by darkness, others guarded by unseen forces.",
		"No map will aid you. Only your wit, your resolve, and your courage will reveal the way.",
		"Forge your path, discover the secrets buried in the maze... and face the force that rules from within."
	],
	"fr": [
		"Tu es entré dans le troisième monde... le cœur du labyrinthe.",
		"Cet endroit n’a pas été construit pour t’accueillir, aventurier – il a été façonné pour te perdre.",
		"Ici, la force seule ne suffit pas.",
		"Un véritable aventurier doit être stratégique, capable de s’adapter aux chemins changeants et aux menaces invisibles.",
		"Chaque couloir, chaque détour, a été placé avec soin... pour défier ton instinct.",
		"De nombreux chemins s’offrent à toi, certains tordus par les ténèbres, d’autres gardés par des forces invisibles.",
		"Aucune carte ne pourra t’aider. Seuls ton intelligence, ta volonté et ton courage dévoileront la voie.",
		"Trace ta route, découvre les secrets enfouis dans ce labyrinthe... et affronte la puissance tapie au fond."
	]
}

# Follow-up quest message
var quest_dialogue_lines := {
	"en": ["QUEST: Find your path through the labyrinth and defeat the one who waits."],
	"fr": ["QUÊTE : Trouve ton chemin dans le labyrinthe et vaincs celui qui t’attend."]
}

# Status messages for section entry
var section_status_lines := {
	"en": {
		"Section_1": "You're just beginning... remain cautious. The dungeon watches every move.",
		"Section_2": "You’ve made progress, adventurer. But dangers grow deeper with each step."
	},
	"fr": {
		"Section_1": "Tu viens de commencer... sois prudent. Le donjon observe chacun de tes gestes.",
		"Section_2": "Tu as progressé, aventurier. Mais les dangers s'intensifient à chaque pas."
	}
}

func _ready():
	MusicManager.stop_music()
	$BGMPlayer.play()
	call_deferred("_get_hud")
	MusicManager.stop_music()
	Global.pause_menu = $PauseMenu
	Global.level_tracker = 3
	
	enemy_count_label = get_tree().get_first_node_in_group("enemy_count")


	lock_camera_to_section("Section_1")  # Start in section 1
	MusicManager.stop_music()

	await get_tree().create_timer(0.8).timeout
	_show_level3_intro()

func _get_hud():
	Global.update_hud()

func _show_level3_intro():
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)

	var lang = TranslationServer.get_locale()
	var lines = level3_intro_lines.get(lang, level3_intro_lines["en"])
	for msg in lines:
		dialogue_box.queue_text(msg)

	dialogue_box.dialogue_finished.connect(_on_intro_finished)
	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()

func _on_intro_finished():
	await get_tree().create_timer(1.0).timeout
	_show_quest_dialogue()


func _show_quest_dialogue():
	var quest_box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(quest_box)

	var lang = TranslationServer.get_locale()
	var lines = quest_dialogue_lines.get(lang, quest_dialogue_lines["en"])
	for msg in lines:
		quest_box.queue_text(msg)

	quest_box.dialogue_finished.connect(_on_quest_finished)
	quest_box.show_dialogue_box()
	quest_box.display_text()

func _on_quest_finished():
	intro_dialogue_done = true


func _on_section_1_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock_camera_to_section("Section_1")
		_show_section_status("Section_1")

func _on_section_2_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock_camera_to_section("Section_2")
		_show_section_status("Section_2")

func _on_section_3_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock_camera_to_section("Section_3")

func _on_section_4_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock_camera_to_section("Section_4")

func _show_section_status(section: String):
	if not intro_dialogue_done:
		return  # Do not show until intro + quest are finished

	var lang = TranslationServer.get_locale()
	var message = section_status_lines.get(lang, section_status_lines["en"]).get(section, "")
	if message == "":
		return

	var status_box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(status_box)
	status_box.queue_text(message)
	status_box.show_dialogue_box()
	status_box.display_text()

func lock_camera_to_section(section_name: String):
	var camera = $Player/Camera2D

	match section_name:
		"Section_1":
			camera.limit_top = -94
			camera.limit_bottom = 1205
			camera.limit_left = -7
			camera.limit_right = 1344

		"Section_2":
			camera.limit_top = -105
			camera.limit_bottom = 1207
			camera.limit_left = 1378
			camera.limit_right = 2724

		"Section_3":
			camera.limit_top = 1283
			camera.limit_bottom = 2573
			camera.limit_left = -2
			camera.limit_right = 1344

		"Section_4":
			camera.limit_top = 1270
			camera.limit_bottom = 2585
			camera.limit_left = 1386
			camera.limit_right = 2743

		_:
			push_error("Unknown section: " + section_name)
			
func _physics_process(delta):
	var previous_enemy_count = enemy_count
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()
	
	# Set text instead of appending with +=
	if enemy_count_label and previous_enemy_count != enemy_count:
		enemy_count_label.text = tr("ENEMIES_REMAINING") + ": " + str(enemy_count)
	
	print("Current enemy count: " + str(enemy_count))
	
	if enemy_count == 0:
		print("All enemies defeated!")
