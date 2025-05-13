extends Area2D

@export var boss_scene: PackedScene
@export var boss_spawn_point: Node2D
@export var trigger_once := true
@export var zoom_duration := 1.5
@export var zoom_amount := 0.65

var already_triggered := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	if already_triggered and trigger_once:
		return
	if not body.is_in_group("player"):
		return

	already_triggered = true
	spawn_boss()

func spawn_boss():
	if not boss_scene or not boss_spawn_point:
		return

	var boss = boss_scene.instantiate()
	boss.global_position = boss_spawn_point.global_position
	get_tree().current_scene.add_child(boss)

	play_roar_sound()
	zoom_camera_on(boss.global_position)

func play_roar_sound():
	var roar_player :=$"../roar_sound"   # Use the node already in your scene
	if roar_player and roar_player is AudioStreamPlayer:
		roar_player.play()

func zoom_camera_on(target_pos: Vector2) -> void:
	var camera := get_viewport().get_camera_2d()
	if not camera:
		return

	# Save original camera state
	var original_zoom = camera.zoom
	var original_drag_horizontal = camera.drag_horizontal_enabled
	var original_drag_vertical = camera.drag_vertical_enabled

	# Disable smoothing for clean snap
	camera.drag_horizontal_enabled = false
	camera.drag_vertical_enabled = false

	# Zoom in
	camera.zoom = Vector2(zoom_amount, zoom_amount)

	# Clamp position using camera limits
	var half_screen = get_viewport_rect().size * 0.5 * camera.zoom
	var min_pos = Vector2(camera.limit_left, camera.limit_top) + half_screen
	var max_pos = Vector2(camera.limit_right, camera.limit_bottom) - half_screen
	var clamped_boss_pos = target_pos.clamp(min_pos, max_pos)

	camera.global_position = clamped_boss_pos

	await get_tree().create_timer(zoom_duration).timeout

	# Reset camera zoom and smoothing
	camera.zoom = original_zoom
	camera.drag_horizontal_enabled = original_drag_horizontal
	camera.drag_vertical_enabled = original_drag_vertical

	# Move back to player (also clamped)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var player_pos = player.global_position.clamp(min_pos, max_pos)
		camera.global_position = player_pos
