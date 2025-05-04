extends Node2D

@export var item_index := 0            # Which item to show
@export var item_size := Vector2i(16, 16)  # Size of one item tile (adjust to your sprite sheet grid)

@onready var sprite := $ItemSprite     # Reference to the Sprite2D node

func _ready():
	set_item_region(item_index)

func set_item_region(index: int):
	if sprite.texture == null:
		return

	var columns = sprite.texture.get_width() / item_size.x
	var x = int(index % columns) * item_size.x
	var y = int(index / columns) * item_size.y
	sprite.region_enabled = true
	sprite.region_rect = Rect2(x, y, item_size.x, item_size.y)
