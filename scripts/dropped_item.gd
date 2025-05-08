extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var item_data: InvItem
var _pending_item: InvItem = null

func setup(item: InvItem):
	_pending_item = item

func _ready():
	if _pending_item:
		item_data = _pending_item
		sprite.texture = item_data.texture
	else:
		print("⚠️ No item data in dropped item")

	# Debug visuals
	sprite.modulate = Color(1, 0, 0)
	sprite.scale = Vector2(2, 2)
	sprite.z_index = 100

	print("✅ DroppedItem is ready at:", global_position)
