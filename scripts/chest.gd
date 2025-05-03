extends Area2D

@export var item_scene: PackedScene    # Scene to drop
@export var item_index_to_drop := 0    # Index of the item to drop from the sprite sheet

var player_in_range := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		drop_item()
		queue_free()  # Optional: remove the chest after opening

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func drop_item():
	if item_scene:
		var item = item_scene.instantiate()
		item.global_position = global_position + Vector2(0, 32)
		if item.has_variable("item_index"):
			item.item_index = item_index_to_drop
		get_tree().current_scene.add_child(item)
