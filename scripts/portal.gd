extends Area2D

@export var next_level_scene: String
@export var is_entry_portal := false
@export var required_key_id: String = "main_boss_key"
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision := $CollisionShape2D


var activated := false

func _ready():
	if is_entry_portal:
		visible = true
		collision.disabled = true
		sprite.play("Emerge")
		await sprite.animation_finished
		sprite.play("Idle")
		await get_tree().create_timer(1.5).timeout
		sprite.play("Disappear")
		await sprite.animation_finished
		queue_free()
	else:
		visible = true
		collision.disabled = false
		sprite.play("Emerge")
		await sprite.animation_finished
		sprite.play("Idle")
		activated = true

func activate_portal():
	visible = true
	sprite.play("Emerge")
	await sprite.animation_finished
	sprite.play("Idle")
	collision.disabled = false
	activated = true

func _on_body_entered(body):
	if not activated:
		return

	if not body.is_in_group("player"):
		return

	print("Checking for key:", required_key_id)

	if "collected_keys" not in body or not body.collected_keys.has(required_key_id):
		print("Portal locked. You need the key to enter.")
		return
	else:
		print("Key found in player. Opening portal.")

	# Player has the key → teleport
	body.visible = false  # hides the player
	activated = false
	collision.disabled = true
	sprite.play("Disappear")
	await sprite.animation_finished
	get_tree().change_scene_to_file(next_level_scene)
