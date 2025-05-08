extends Area2D

@export var item: InvItem
@export var heal_percentage := 10.0

var player_in_range = false
var player_ref = null

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("use_item"):
		Global.heal(heal_percentage)
		print("Used red potion — healed", heal_percentage, "%!")
		queue_free()

	elif player_in_range and Input.is_action_just_pressed("collect_item"):
		player_ref.collect(item)
		print("Collected red potion into inventory")
		queue_free()
