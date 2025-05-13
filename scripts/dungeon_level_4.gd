extends Node2D

var enemy_count := 0
var enemy_count_label
var boss_spawned := false

@export var boss_scene: PackedScene
@onready var spawn_point := $BossSpawnPoint
@onready var boss_camera := $BossCamera
@onready var player_camera := $World/Player/Camera2D
@onready var roar_player := $BossRoar
@onready var player := $World/Player

var level4_intro_lines := {
	"en": [
		"Legends speak of this place as a fortress of forgotten knowledge, sealed by time and sorrow.",
		"Beneath its cold stone, curses linger... and many who entered never returned.",
		"You’ve succeeded in defeating the terrible Minotaur... but your path is not yet over.",
		"This is it, adventurer... the final descent.",
		"The dungeon breathes silence, yet danger lurks in every shadow.",
		"All you’ve learned, all you’ve endured... led you here.",
		"Now bring this journey to its close... or be lost within these walls.",
		"Let your name echo beyond the depths. This may be the end... or just the beginning of your legend."
	],
	"fr": [
		"Les légendes parlent de ce lieu comme d’une forteresse de savoir oublié, scellée par le temps et le chagrin.",
		"Dans ses pierres glacées, les malédictions subsistent... et rares sont ceux qui en sont ressortis.",
		"Tu as réussi à vaincre le terrible Minotaure... mais ton chemin n’est pas encore terminé.",
		"Nous y voilà, aventurier... la descente finale.",
		"Le donjon respire le silence, mais le danger rôde dans chaque recoin.",
		"Tout ce que tu as appris, tout ce que tu as traversé... t’a mené ici.",
		"Achève maintenant ton voyage... ou sois perdu à jamais entre ces murs.",
		"Que ton nom résonne au-delà des profondeurs. C’est peut-être la fin... ou le début de ta légende."
	]
}


var quest_lines := {
	"en": ["QUEST: Find and eliminate all the enemies."],
	"fr": ["QUÊTE : Trouve et élimine tous les ennemis."]
}

var boss_quest_lines := {
	"en": ["QUEST: Defeat the Boss."],
	"fr": ["QUÊTE : Vaincs le boss."]
}

func _ready() -> void:
	MusicManager.stop_music()
	$BGMPlayer.play()
	call_deferred("_get_hud")
	Global.pause_menu = $PauseMenu
	Global.level_tracker = 4

	enemy_count_label = get_tree().get_first_node_in_group("enemy_count")

	await get_tree().create_timer(0.8).timeout
	await _show_level4_intro()
	await get_tree().create_timer(0.5).timeout
	await _show_quest_dialogue()
	await get_tree().create_timer(10).timeout

func _get_hud():
	Global.update_hud()

func _physics_process(delta):
	var previous_enemy_count = enemy_count

	if boss_spawned:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()

	if enemy_count_label and previous_enemy_count != enemy_count:
		enemy_count_label.text = tr("ENEMIES_REMAINING") + ": " + str(enemy_count)

	if enemy_count == 0:
		boss_spawned = true
		await spawn_boss_cinematic()
		enemy_count_label.text = ""
		await get_tree().create_timer(0.5).timeout
		await _show_boss_quest_dialogue()

func spawn_boss_cinematic():
	boss_camera.enabled = true
	player_camera.enabled = false

	await get_tree().create_timer(0.5).timeout

	var boss_instance = boss_scene.instantiate()
	boss_instance.global_position = spawn_point.global_position
	add_child(boss_instance)

	if boss_instance.has_node("Sprite2D"):
		var sprite := boss_instance.get_node("Sprite2D")
		sprite.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 1.0, 1.0)

	if roar_player:
		roar_player.play()

	await get_tree().create_timer(2.0).timeout

	player_camera.enabled = true
	boss_camera.enabled = false

func _show_level4_intro() -> void:
	var box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(box)

	var lang = TranslationServer.get_locale()
	var lines = level4_intro_lines.get(lang, level4_intro_lines["en"])
	for msg in lines:
		box.queue_text(msg)

	box.show_dialogue_box()
	await box.display_text()
	await box.dialogue_finished
	box.queue_free()
	

func _show_quest_dialogue() -> void:
	var box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(box)

	var lang = TranslationServer.get_locale()
	var lines = quest_lines.get(lang, quest_lines["en"])
	for msg in lines:
		box.queue_text(msg)

	box.show_dialogue_box()
	await box.display_text()
	await box.dialogue_finished
	box.queue_free()

func _show_boss_quest_dialogue() -> void:
	var box = preload("res://scenes/dialogue_main_game.tscn").instantiate()
	get_tree().root.add_child(box)

	var lang = TranslationServer.get_locale()
	var lines = boss_quest_lines.get(lang, boss_quest_lines["en"])
	for msg in lines:
		box.queue_text(msg)

	box.show_dialogue_box()
	await box.display_text()
	await box.dialogue_finished
	box.queue_free()
