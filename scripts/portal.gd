extends Area2D

@export var next_level_scene: String
@export var is_entry_portal := false
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision := $CollisionShape2D

var activated := false

func _ready():
	# Entry portal appears at scene start (used on new level spawn)
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
		# Exit portal is inactive until boss dies (for now just show it directly for testing)
		visible = true  # TEMP: Show immediately for testing
		collision.disabled = false  # TEMP: Enable collision immediately
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
	if !activated:
		return

	# 🔒 TO IMPLEMENT LATER: Key check logic when you add enemies/items
	# if !body.has_method("has_key"): return
	# if body.has_key():
	#     pass
	# else:
	#     print("Portal locked. Key required.")
	#     return

	# TEMP: Always teleport for now
	activated = false
	collision.disabled = true
	sprite.play("Disappear")
	await sprite.animation_finished
	get_tree().change_scene_to_file(next_level_scene)
