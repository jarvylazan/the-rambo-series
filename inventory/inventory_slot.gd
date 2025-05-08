extends Button

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var slot_sprite: Sprite2D = $Sprite2D
@onready var tooltip_label := preload("res://scenes/TooltipLabel.tscn")  

var inventory_slot: InvSlot
var tooltip_instance: Label = null

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
		tooltip_instance.text = inventory_slot.item.name
		tooltip_instance.global_position = get_global_mouse_position() + Vector2(16, -32)
		get_tree().current_scene.add_child(tooltip_instance)

func _on_mouse_exited():
	if tooltip_instance:
		tooltip_instance.queue_free()
		tooltip_instance = null
