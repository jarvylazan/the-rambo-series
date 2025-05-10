extends Area2D

@export var item_data: InvItem

func _ready():
	if item_data:
		$Sprite2D.texture = item_data.texture
	else:
		print("No item_data passed!")

	connect("body_entered", Callable(self, "_on_DroppedItem_body_entered"))

func _on_DroppedItem_body_entered(body):
	if body and body.is_in_group("player") and "collect" in body:
		print("Called player.collect():", item_data.name)
		body.collect(item_data)
		queue_free()
