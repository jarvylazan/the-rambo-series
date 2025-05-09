extends Control
class_name InventoryUI

@onready var inv: Inv = preload("res://inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var selected_slot_gui: Button = null
var selected_slot_data: InvSlot = null

var is_open = false

func _ready():
	add_to_group("InventoryUI")
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

	if is_open and selected_slot_data and Input.is_action_just_pressed("use_item"):
		print("🟦 I key pressed for:", selected_slot_data.item.name)
		_use_selected_item()


func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true

# LEFT CLICK SLOT SELECTION
func slot_clicked(slot_gui):
	var clicked_index = slots.find(slot_gui)

	if selected_slot_gui == null:
		if slot_gui.inventory_slot and slot_gui.inventory_slot.item:
			selected_slot_gui = slot_gui
			selected_slot_data = slot_gui.inventory_slot
			if clicked_index != -1:
				inv.slots[clicked_index] = InvSlot.new()
			slot_gui.inventory_slot = null
			slot_gui.update_slot()
	else:
		var selected_index = slots.find(selected_slot_gui)
		if clicked_index == selected_index:
			selected_slot_gui.inventory_slot = selected_slot_data
			if selected_index != -1:
				inv.slots[selected_index] = selected_slot_data
			selected_slot_gui.update_slot()
		elif clicked_index != -1 and selected_index != -1:
			var target_data: InvSlot = slot_gui.inventory_slot
			slot_gui.inventory_slot = selected_slot_data
			selected_slot_gui.inventory_slot = target_data
			inv.slots[clicked_index] = selected_slot_data
			inv.slots[selected_index] = target_data
			slot_gui.update_slot()
			selected_slot_gui.update_slot()

		selected_slot_gui = null
		selected_slot_data = null

	inv.update.emit()

# RIGHT CLICK TO DROP (supports shift-drop-all)
func slot_right_clicked(slot_gui, drop_all := false):
	if slot_gui.inventory_slot and slot_gui.inventory_slot.item:
		var item_data = slot_gui.inventory_slot.item

		if drop_all:
			var amount = slot_gui.inventory_slot.amount
			for i in range(amount):
				_drop_item(item_data)

			var i = slots.find(slot_gui)
			if i != -1:
				inv.slots[i] = InvSlot.new()
			slot_gui.inventory_slot = null
		else:
			_drop_item(item_data)
			slot_gui.inventory_slot.amount -= 1
			if slot_gui.inventory_slot.amount <= 0:
				var i = slots.find(slot_gui)
				if i != -1:
					inv.slots[i] = InvSlot.new()
				slot_gui.inventory_slot = null

		slot_gui.update_slot()
		inv.update.emit()

# DROP ITEM AS AREA2D
func _drop_item(inv_item: InvItem):
	if not inv_item or not inv_item.texture:
		return

	var drop_area := Area2D.new()
	drop_area.name = "DroppedItem"
	drop_area.monitoring = true
	drop_area.collision_layer = 5
	drop_area.collision_mask = 2

	var sprite := Sprite2D.new()
	sprite.texture = inv_item.texture
	sprite.scale = Vector2(0.5, 0.5)
	sprite.z_index = 1
	drop_area.add_child(sprite)

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 10
	shape.shape = circle
	shape.disabled = false
	drop_area.add_child(shape)

	var base_position: Vector2
	var spawn_point = get_parent().get_node("DropSpawnPoint")
	if spawn_point:
		base_position = spawn_point.global_position
	else:
		base_position = Vector2(400, 400)

	var offset := Vector2(randi_range(-50, 50), randi_range(-50, 50))
	drop_area.global_position = base_position + offset

	get_tree().current_scene.add_child(drop_area)

	drop_area.connect("body_entered", Callable(self, "_on_drop_collected").bind(drop_area, inv_item))

# COLLECT ITEM ON TOUCH
func _on_drop_collected(body: Node, drop_area: Area2D, item: InvItem):
	if body is CharacterBody2D:
		# Add directly to inventory
		var item_added := false
		for i in range(inv.slots.size()):
			var slot := inv.slots[i]
			if slot.item and slot.item.name == item.name:
				slot.amount += 1
				item_added = true
				break

		if not item_added:
			for i in range(inv.slots.size()):
				if inv.slots[i].item == null:
					inv.slots[i] = InvSlot.new()
					inv.slots[i].item = item
					inv.slots[i].amount = 1
					break

		inv.update.emit()
		drop_area.queue_free()

# DROP ONE FROM BUTTON (if still used)
func _on_DropOneButton_pressed():
	if selected_slot_data:
		_drop_item(selected_slot_data.item)
		selected_slot_data.amount -= 1
		if selected_slot_data.amount <= 0:
			var i = slots.find(selected_slot_gui)
			if i != -1:
				inv.slots[i] = InvSlot.new()
			selected_slot_gui.inventory_slot = null
			selected_slot_gui.update_slot()
			selected_slot_gui = null
			selected_slot_data = null
		else:
			selected_slot_gui.update_slot()

		inv.update.emit()

func _on_DropAllButton_pressed():
	if not selected_slot_data or selected_slot_data.amount <= 0:
		return

	var item_data = selected_slot_data.item
	var amount = selected_slot_data.amount

	for i in range(amount):
		_drop_item(item_data)

	var i = slots.find(selected_slot_gui)
	if i != -1:
		inv.slots[i] = InvSlot.new()

	selected_slot_gui.inventory_slot = null
	selected_slot_gui.update_slot()
	selected_slot_gui = null
	selected_slot_data = null

	inv.update.emit()

func _on_UseItemButton_pressed():
	_use_selected_item()

func _use_selected_item():
	if selected_slot_data and selected_slot_data.item:
		var item_name = selected_slot_data.item.name

		match item_name:
			"red_potion":
				Global.heal(10)
			"yellow_potion":
				Global.heal(100)
			"blue_potion":
				Global.apply_power_boost()
			_:
				print("Item can't be used directly.")
				return

		# Remove used item
		selected_slot_data.amount -= 1
		if selected_slot_data.amount <= 0:
			var i = slots.find(selected_slot_gui)
			if i != -1:
				inv.slots[i] = InvSlot.new()
			selected_slot_gui.inventory_slot = null
			selected_slot_gui.update_slot()
			selected_slot_gui = null
			selected_slot_data = null
		else:
			selected_slot_gui.update_slot()

		inv.update.emit()
