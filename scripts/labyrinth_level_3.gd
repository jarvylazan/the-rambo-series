extends Node2D

var enemy_count := 0
var enemy_count_label  # Will properly initialize this in _ready

func _ready():
	call_deferred("_get_hud")
	MusicManager.stop_music()
	Global.pause_menu = $PauseMenu
	Global.level_tracker = 3
	enemy_count_label = get_tree().get_first_node_in_group("enemy_count")

	lock_camera_to_section("Section_1")  # Start in section 1
	MusicManager.stop_music()
	
func _get_hud():
	Global.update_hud()

func _on_section_1_trigger_body_entered(body: Node2D) -> void:
	print("Entered by: ", body.name)
	if body.name == "Player":
		print("Locking to Section 1")
		lock_camera_to_section("Section_1")

func _on_section_2_trigger_body_entered(body: Node2D) -> void:
	print("Entered by: ", body.name)
	if body.name == "Player":
		print("Locking to Section 2")
		lock_camera_to_section("Section_2")
		
func _on_section_3_trigger_body_entered(body: Node2D) -> void:
	print("Entered by: ", body.name)
	if body.name == "Player":
		print("Locking to Section 3")
		lock_camera_to_section("Section_3")

func _on_section_4_trigger_body_entered(body: Node2D) -> void:
	print("Entered by: ", body.name)
	if body.name == "Player":
		print("Locking to Section 4")
		lock_camera_to_section("Section_4")

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
