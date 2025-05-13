extends Node2D

# Load both dialogue box scenes
var DialogueBoxScene := preload("res://scenes/tutorial_dialogue_box_ui.tscn")
var MainGameDialogueBoxScene := preload("res://scenes/dialogue_main_game.tscn")

# First lore dialogue
var world_intro_dialogue_lines := {
	"en": [
		"You’ve taken your first steps, adventurer... now the true journey begins.",
		"This desert is one of the many worlds I forged... once empty, now claimed by corrupted beasts.",
		"The creatures here twisted this realm into their domain.",
		"It breathes with danger and mystery. Watch the sand… it hides more than dust.",
		"Explore the ruins, uncover the truth, and conquer what lies ahead.",
		"Many enemies await you... each a challenge of its own.",
		"This level will test your courage, patience, and ability to overcome the adversary.",
		"Defeat them if you must... but know this: somewhere in this scorched land, the one who commands them still hides.",
		"Find him... or eliminate them all. Either way, the path forward will be revealed.",
		"This is your first true trial. Let it be a beginning, not an end."
	],

	"fr": [
		"Tu as fait tes premiers pas, aventurier... maintenant commence le vrai voyage.",
		"Ce désert est l’un des mondes que j’ai créés... autrefois vide, désormais déformé par des bêtes corrompues.",
		"Ces créatures ont fait de ce royaume leur domaine.",
		"Il respire le danger et le mystère. Attention au sable... il cache plus que de la poussière.",
		"Explore les ruines, découvre la vérité, et conquiers ce qui t’attend.",
		"De nombreux ennemis t’attendent... chacun avec ses propres défis.",
		"Ce niveau mettra à l’épreuve ton courage, ta patience et ta capacité à surmonter l’adversité.",
		"Tu peux tous les vaincre... mais sache-le : quelque part dans ces terres brûlées, celui qui les dirige se cache encore.",
		"Trouve-le... ou élimine-les tous. Dans les deux cas, le chemin s’ouvrira.",
		"Voici ta première véritable épreuve. Qu’elle soit un commencement, et non une fin."
	]
}

# Second win-condition explanation dialogue
var win_condition_dialogue_lines := {
	"en": [
		"QUEST: Find all the enemies and defeat them, or locate the domain of the boss and destroy him to win this world."
	],
	"fr": [
		"QUÊTE: Trouve tous les ennemis et élimine-les, ou localise le domaine du boss et détruis-le pour remporter ce monde."
	]
}

var dialogue_box  # Dialogue box instance

var enemy_count := 0
var enemy_count_label  # Will properly initialize this in _ready
var hud
func _ready():
	call_deferred("_get_hud")
	Global.pause_menu = $PauseMenu
	MusicManager.stop_music()
	
	Global.level_tracker = 2
	
	# Get the EnemyCountLabel from the Player's Hud
	enemy_count_label = get_tree().get_first_node_in_group("enemy_count")
		# Instantiate and add dialogue box
	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(dialogue_box)
	

	# Connect signal
	dialogue_box.dialogue_finished.connect(_on_intro_finished)

	# Set up camera
	var player = $Player
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.position = Vector2.ZERO
	camera.make_current()
	camera.zoom = Vector2(0.85, 0.85)
	camera.limit_left = -2734
	camera.limit_top = 227
	camera.limit_right = 6683
	camera.limit_bottom = 3750
	
	# Lock player movement
	player.can_move = false

	# Start first dialogue after short delay
	await get_tree().create_timer(2.5).timeout

	var language = TranslationServer.get_locale()
	for line in world_intro_dialogue_lines.get(language, world_intro_dialogue_lines["en"]):
		dialogue_box.queue_text(line)

	dialogue_box.show_dialogue_box()
	await dialogue_box.display_text()
	
	var hud = get_node("Hud")
	
	hud.update_ammo(Global.bullet_count)
	hud.update_coins(Global.coin_count)


func _get_hud():
	hud = get_node("Hud")
func _on_intro_finished():
	print("Tutorial dialogue finished.")

	# Disconnect and remove first dialogue box
	dialogue_box.dialogue_finished.disconnect(_on_intro_finished)
	dialogue_box.queue_free()

	# Unlock player movement immediately
	$Player.can_move = true

	# Optional short delay before second message
	await get_tree().create_timer(1.0).timeout

	# Show second dialogue (main game style)
	var second_dialogue_box = MainGameDialogueBoxScene.instantiate()
	get_tree().root.add_child(second_dialogue_box)

	var language = TranslationServer.get_locale()
	for line in win_condition_dialogue_lines.get(language, win_condition_dialogue_lines["en"]):
		second_dialogue_box.queue_text(line)

	second_dialogue_box.show_dialogue_box()
	await second_dialogue_box.display_text()

	print("Win condition dialogue displayed.")

# Portal logic
@onready var portal_scene := preload("res://scenes/portal.tscn")
var portal_spawned := false
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
		
	if not portal_spawned and enemies.all(func(e): not e.is_boss):
		_spawn_portal_near_player()
		portal_spawned = true

func _spawn_portal_near_player():
	var portal = portal_scene.instantiate()
	portal.required_key_id = "desert_clear_key"
	portal.next_level_scene = "res://scenes/Labyrinth_Level3.tscn"

	var player = $Player
	portal.global_position = player.global_position + Vector2(96, 0)
	get_tree().current_scene.add_child(portal)

	if not player.collected_keys.has("desert_clear_key"):
		player.collected_keys.append("desert_clear_key")
		print("Non-boss portal key granted.")
