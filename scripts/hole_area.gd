extends Area2D
@onready var scream_sound := $"../ScreamSound"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	scream_sound.play()  # 🔊 Play scream before hiding and dying

	body.visible = false
	await get_tree().create_timer(1.0).timeout  # Wait for scream

	# Properly kill player through damage system
	Global.take_damage(100)  # 100% damage = health reaches 0

	print("Player fell in a hole and died.")
