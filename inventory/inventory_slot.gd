extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var slot_sprite: Sprite2D = $Sprite2D

var slot_data: InvSlot

func update(slot: InvSlot):
	slot_data = slot
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
		slot_sprite.frame = 0
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		slot_sprite.frame = 1
		amount_text.visible = slot.amount > 1
		amount_text.text = str(slot.amount)

# Step 1: Start drag
func get_drag_data(_position):
	if slot_data and slot_data.item:
		var preview = TextureRect.new()
		preview.texture = slot_data.item.texture
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.custom_minimum_size = Vector2(32, 32)
		set_drag_preview(preview)
		return slot_data

# Step 2: Accept drag
func can_drop_data(_position, data):
	return data is InvSlot

# Step 3: Handle drop
func drop_data(_position, data):
	if data is InvSlot:
		var temp_item = slot_data.item
		var temp_amount = slot_data.amount
		slot_data.item = data.item
		slot_data.amount = data.amount
		data.item = temp_item
		data.amount = temp_amount
		get_tree().call_group("InventoryUI", "update_slots")
