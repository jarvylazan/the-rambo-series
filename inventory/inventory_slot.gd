extends Button

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var slot_sprite: Sprite2D = $Sprite2D
@onready var tooltip_label := preload("res://scenes/TooltipLabel.tscn")
@onready var selection_overlay: ColorRect = $SelectionOverlay

var inventory_slot: InvSlot
var tooltip_instance: Label = null

func update_slot():
	if !inventory_slot or !inventory_slot.item:
		item_visual.visible = false
		amount_text.visible = false
		slot_sprite.frame = 0
		slot_sprite.modulate = Color(1, 1, 1)  # default white
		return

	# Item is present
	item_visual.visible = true
	item_visual.texture = inventory_slot.item.texture
	slot_sprite.frame = 1

	# Show count if >1
	if inventory_slot.amount > 1:
		amount_text.visible = true
		amount_text.text = str(inventory_slot.amount)
	else:
		amount_text.visible = false

	# Potion check (for usability visual cue)
	var item_name := inventory_slot.item.name
	var is_usable_potion := item_name == "red_potion" or item_name == "yellow_potion" or item_name == "blue_potion"

	# Rarity color (base)
	match inventory_slot.item.rarity:
		"common":
			slot_sprite.modulate = Color(1, 1, 1)  # white
		"rare":
			slot_sprite.modulate = Color(0.5, 0.7, 1)  # blue
		"unique":
			slot_sprite.modulate = Color(0.9, 0.6, 0.3)  # orange/gold-ish
		"legendary":
			slot_sprite.modulate = Color(0.8, 0.2, 1.0)  # purple
		_:
			slot_sprite.modulate = Color(1, 1, 1)


	# Optional: Make usable potions glow slightly over rarity color
	if is_usable_potion:
		slot_sprite.modulate *= Color(1.1, 1.1, 0.95)  # Brighten a bit


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().call_group("InventoryUI", "slot_clicked", self)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			var is_shift: bool = event.shift_pressed
			get_tree().call_group("InventoryUI", "slot_right_clicked", self, is_shift)

func _on_mouse_entered():
	if inventory_slot and inventory_slot.item:
		tooltip_instance = tooltip_label.instantiate()
		tooltip_instance.text = "%s (%s)" % [
			inventory_slot.item.name.capitalize(),
			inventory_slot.item.rarity.capitalize()
		]
		tooltip_instance.global_position = get_global_mouse_position() + Vector2(16, -32)
		get_tree().current_scene.add_child(tooltip_instance)


func _on_mouse_exited():
	if tooltip_instance:
		tooltip_instance.queue_free()
		tooltip_instance = null
		
var is_selected := false

func set_selected(state: bool):
	is_selected = state
	selection_overlay.visible = is_selected
