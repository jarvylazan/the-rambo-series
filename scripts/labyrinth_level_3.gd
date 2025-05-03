extends Node2D

func _ready():
	lock_camera_to_section("Section_1")  # Start in section 1

func _on_section_1_trigger_body_entered(body: Node2D) -> void:
	print("Entered by: ", body.name)
	if body.name == "Player":
		print("Locking to Section 1")
		lock_camera_to_section("Section_1")

func lock_camera_to_section(section_name: String):
	var camera = $Player/Camera2D

	match section_name:
		"Section_1":
			camera.limit_top = -94
			camera.limit_bottom = 1205
			camera.limit_left = -7
			camera.limit_right = 1344

		_:
			push_error("Unknown section: " + section_name)


func _on_section_2_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
