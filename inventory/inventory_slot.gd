extends Button

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var slot_sprite: Sprite2D = $Sprite2D

var inventory_slot: InvSlot

func update_slot():
	if !inventory_slot or !inventory_slot.item:
		item_visual.visible = false
		amount_text.visible = false
		slot_sprite.frame = 0
	else:
		item_visual.visible = true
		item_visual.texture = inventory_slot.item.texture
		slot_sprite.frame = 1
		if inventory_slot.amount > 1:
			amount_text.visible = true
			amount_text.text = str(inventory_slot.amount)
		else:
			amount_text.visible = false

func _pressed():
	# Let the InventoryUI handle the logic
	get_tree().call_group("InventoryUI", "slot_clicked", self)
