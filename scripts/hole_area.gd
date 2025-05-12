extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	body.visible = false

	# Properly kill player through damage system
	Global.take_damage(100)  # 100% damage = health reaches 0

	print("Player fell in a hole and died.")
