extends CharacterBody2D
class_name Enemy

@export var speed: float = 150.0
@export var health: int = 100
@export var max_health: int = 100
@export var damage: int = 10
@export var attack_range: float = 50.0
@export var detection_range: float = 200.0
@export var attack_cooldown: float = 1.0
@export var next_level_scene: String = ""  # Set this in each boss scene

#------BOSS--------
@export var is_boss := false
@onready var PortalScene := preload("res://scenes/portal.tscn")  # Update path as needed
var minotaur_health_bar_offset = Vector2(-30, -118)
var ghoul_health_bar_offset = Vector2(-30, -100)
var dwarf_health_bar_offset = Vector2(-30, -80)

#--------------------------
var drop_dialogue_lines := {}
var drop_dialogue_triggered := false
var health_bar := preload("res://scenes/enemy_health_bar.tscn")
var health_bar_instance = null
var health_bar_offset = Vector2(-30, -75)

@export var patrol_distance: float = 40.0
@export var patrol_speed: float = 20.0

var is_attacking := false
var can_attack := true
var is_dead := false
var is_hurt := false
var direction := Vector2.LEFT
var player: Node2D

var patrol_origin: Vector2
var patrol_direction := 1
var patrol_flip_cooldown := false

@export var max_drops: int = 2
@export var drop_chance: float = 0.5
@export var possible_drops: Array[InvItem]

var DroppedItemScene := preload("res://scenes/dropped_item.tscn")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	patrol_origin = global_position
	
	if is_in_group("minotaur"):
		health_bar_offset = minotaur_health_bar_offset
	elif is_in_group("dwarf"):
		health_bar_offset = dwarf_health_bar_offset
	elif is_in_group("ghoul"):
		health_bar_offset = ghoul_health_bar_offset

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var movement_this_frame = velocity

	if player:
		var dist_to_player = global_position.distance_to(player.global_position)
		if dist_to_player <= attack_range:
			var flip_left = player.global_position.x < global_position.x
			velocity = Vector2.ZERO
			attack(flip_left)
		elif dist_to_player <= detection_range:
			move_towards(player.global_position)
		else:
			patrol()

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO

	update_animation(movement_this_frame)
	
	if health_bar_instance:
		health_bar_instance.global_position = global_position + health_bar_offset

func patrol() -> void:
	var offset = global_position.x - patrol_origin.x
	if abs(offset) >= patrol_distance and not patrol_flip_cooldown:
		patrol_direction *= -1
		patrol_flip_cooldown = true
		await get_tree().create_timer(0.5).timeout
		patrol_flip_cooldown = false
	direction = Vector2(patrol_direction, 0)
	velocity = direction * patrol_speed

func update_animation(last_velocity: Vector2) -> void:
	if is_dead:
		anim.play("die")
	elif is_hurt:
		anim.play("hurt")
	elif last_velocity.length() > 1:
		anim.play("move")
	elif is_attacking:
		anim.play("attack")
	else:
		anim.play("idle")
	if not is_attacking:
		anim.flip_h = direction.x < 0

func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	health -= amount
	is_hurt = true
	anim.play("hurt")
	
	if health < max_health and not health_bar_instance:
		_create_health_bar()
	
	if health_bar_instance:
		var health_percent = float(health) / float(max_health) * 100
		health_bar_instance.value = health_percent
	
	if health <= 0:
		die()
	else:
		await anim.animation_finished
		is_hurt = false

func _create_health_bar() -> void:
	health_bar_instance = health_bar.instantiate()
	
	var health_percent = float(health) / float(max_health) * 100
	health_bar_instance.value = health_percent
	health_bar_instance.min_value = 0
	health_bar_instance.max_value = 100
	
	health_bar_instance.global_position = global_position + health_bar_offset
	
	get_tree().current_scene.add_child(health_bar_instance)

func die() -> void:
	is_dead = true
	anim.play("die")
	velocity = Vector2.ZERO
	
	
	if health_bar_instance:
		health_bar_instance.queue_free()
		health_bar_instance = null
	
	await anim.animation_finished
	_on_Death()

func _on_Death():
	var num_drops := max_drops
	var used_positions: Array[Vector2] = []
	var drop_radius := 64

	for i in range(num_drops):
		if randf() < drop_chance and possible_drops.size() > 0:
			var item = possible_drops[randi() % possible_drops.size()]
			var drop = DroppedItemScene.instantiate()
			drop.item_data = item

			var offset := Vector2.ZERO
			var attempts := 0
			while attempts < 10:
				var angle = randf_range(0, TAU)
				var distance = randi_range(drop_radius, drop_radius + 48)
				offset = Vector2.RIGHT.rotated(angle) * distance
				offset = offset.snapped(Vector2(8, 8))
				if not used_positions.has(offset):
					used_positions.append(offset)
					break
				attempts += 1

			drop.global_position = global_position + offset
			get_tree().current_scene.add_child(drop)

	# Spawn portal if this is a boss
	if is_boss:
		var portal = PortalScene.instantiate()
		portal.global_position = global_position + Vector2(96, 0)

		portal.set("next_level_scene", next_level_scene)  # FIXED!
		get_tree().current_scene.add_child(portal)

		if portal.has_method("activate_portal"):
			portal.activate_portal()



	# Dialogue once
	if not drop_dialogue_triggered and drop_dialogue_lines and not drop_dialogue_lines.is_empty():
		_show_drop_dialogue()
		drop_dialogue_triggered = true

	queue_free()


func _show_drop_dialogue():
	if drop_dialogue_lines.is_empty():
		return
	var dialogue_box = preload("res://scenes/tutorial_dialogue_box_ui.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)
	var lang = TranslationServer.get_locale()
	var lines = drop_dialogue_lines.get(lang, drop_dialogue_lines.get("en", []))
	for msg in lines:
		dialogue_box.queue_text(msg)
	dialogue_box.show_dialogue_box()
	dialogue_box.display_text()

func attack(flip_left: bool) -> void:
	if is_attacking or is_dead or not can_attack:
		return
	is_attacking = true
	can_attack = false
	direction = Vector2.LEFT if flip_left else Vector2.RIGHT
	anim.flip_h = direction.x < 0
	anim.play("attack")
	var hitbox_anim = "attack_left" if flip_left else "attack_right"
	anim_player.play(hitbox_anim)
	await anim_player.animation_finished
	is_attacking = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func move_towards(target_position: Vector2) -> void:
	if is_dead or is_attacking:
		return
	var to_target = target_position - global_position
	direction = Vector2(sign(to_target.x), 0)
	velocity = to_target.normalized() * speed
