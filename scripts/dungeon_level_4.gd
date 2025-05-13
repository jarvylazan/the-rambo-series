extends Node2D

var enemy_count := 0
var enemy_count_label  # Will properly initialize this in _ready
var boss_spawned := false

@export var boss_scene: PackedScene
@onready var spawn_point := $BossSpawnPoint
@onready var boss_camera := $BossCamera
@onready var player_camera :=  $World/Player/Camera2D# Adjust path if needed
@onready var roar_player :=  $BossRoar # Optional

func _ready() -> void:
	Global.pause_menu = $PauseMenu
	
	Global.level_tracker = 4
	
	# Get the EnemyCountLabel from the group
	enemy_count_label = get_tree().get_first_node_in_group("enemy_count")
	var hud = get_node("Hud")
	hud.update_ammo(Global.bullet_count)
	hud.update_coins(Global.coin_count)

func _physics_process(delta): # Fixed function name with underscores
	var previous_enemy_count = enemy_count
	
	if boss_spawned:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()
	
	
	# Set text instead of appending with +=
	if enemy_count_label and previous_enemy_count != enemy_count:
		enemy_count_label.text = tr("ENEMIES_REMAINING") + ": " + str(enemy_count)
	
	print("Current enemy count: " + str(enemy_count))
	
	if enemy_count == 0:
		print("All enemies defeated!")	
		
		boss_spawned = true
		await spawn_boss_cinematic()

func spawn_boss_cinematic():
	# 1. Switch to boss camera
	boss_camera.enabled = true
	player_camera.enabled = false

	# 2. Wait 0.5 seconds
	await get_tree().create_timer(0.5).timeout

	# 3. Spawn boss at the marker position
	var boss_instance = boss_scene.instantiate()
	boss_instance.global_position = spawn_point.global_position
	add_child(boss_instance)

	# 4. Fade in the boss (optional)
	if boss_instance.has_node("Sprite2D"):
		var sprite := boss_instance.get_node("Sprite2D")
		sprite.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 1.0, 1.0)

	# 5. Play roar sound (optional)
	if roar_player:
		roar_player.play()

	# 6. Wait before switching camera back
	await get_tree().create_timer(2.0).timeout

	# 7. Return to player camera
	player_camera.enabled = true
	boss_camera.enabled = false
