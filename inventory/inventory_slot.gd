extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var slot_sprite: Sprite2D = $Sprite2D  # This is the VFrame-based background

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
		slot_sprite.frame = 0  # Empty slot = default color (frame 0)
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		slot_sprite.frame = 1  # Filled slot = highlight color (frame 1)

		if slot.amount > 1:
			amount_text.visible = true
			amount_text.text = str(slot.amount)
		else:
			amount_text.visible = false
