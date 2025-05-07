extends Control
class_name InventoryUI  # 👈 Needed for call_group

@onready var inv: Inv = preload("res://inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var selected_slot_gui: Button = null

var selected_slot_data: InvSlot = null


var is_open = false

func _ready():
	add_to_group("InventoryUI")  # 👈 Now your slots can call "update_slots"
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].inventory_slot = inv.slots[i]
		slots[i].update_slot()


func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()

func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true

func slot_clicked(slot_gui):
	var clicked_index = slots.find(slot_gui)

	if selected_slot_gui == null:
		# First click: pick up the item from the clicked slot
		if slot_gui.inventory_slot and slot_gui.inventory_slot.item:
			selected_slot_gui = slot_gui
			selected_slot_data = slot_gui.inventory_slot
			if clicked_index != -1:
				inv.slots[clicked_index] = InvSlot.new()  # Clear in model
			slot_gui.inventory_slot = null
			slot_gui.update_slot()

	else:
		var selected_index = slots.find(selected_slot_gui)

		if clicked_index == selected_index:
			# Cancel selection if same slot is clicked again
			selected_slot_gui.inventory_slot = selected_slot_data
			if selected_index != -1:
				inv.slots[selected_index] = selected_slot_data
			selected_slot_gui.update_slot()
		elif clicked_index != -1 and selected_index != -1:
			# Swap if both slots contain data
			var target_data: InvSlot = slot_gui.inventory_slot
			slot_gui.inventory_slot = selected_slot_data
			selected_slot_gui.inventory_slot = target_data

			# Sync to model
			inv.slots[clicked_index] = selected_slot_data
			inv.slots[selected_index] = target_data

			slot_gui.update_slot()
			selected_slot_gui.update_slot()

		# Reset selection
		selected_slot_gui = null
		selected_slot_data = null

	inv.update.emit()
