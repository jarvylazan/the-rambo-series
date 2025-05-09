extends Node2D

func _ready():
	Global.pause_menu = $PauseMenu
	lock_camera_to_section("Section_1")  # Start in section 1

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
