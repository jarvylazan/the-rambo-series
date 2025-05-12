extends Node2D

var enemy_count := 0
var boss_spawned := false

@export var boss_scene: PackedScene
@onready var spawn_point := $BossSpawnPoint
@onready var boss_camera := $BossCamera
@onready var player_camera :=  $World/Player/Camera2D# Adjust path if needed
@onready var roar_player :=  $BossRoar # Optional

func _physics_process(delta):
	if boss_spawned:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()

	if enemy_count == 0:
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
