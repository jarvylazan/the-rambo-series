extends CharacterBody2D
class_name Enemy

@export var speed: float = 150.0
@export var health: int = 100
@export var max_health: int = 100
@export var damage: int = 10
@export var attack_range: float = 50.0
@export var detection_range: float = 200.0
@export var attack_cooldown: float = 1.0

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


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	patrol_origin = global_position

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var movement_this_frame = velocity  # Save current velocity for animation

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

	if health <= 0:
		die()
	else:
		await anim.animation_finished
		is_hurt = false

func die() -> void:
	is_dead = true
	anim.play("die")
	velocity = Vector2.ZERO
	await anim.animation_finished
	queue_free()

func attack(flip_left: bool) -> void:
	if is_attacking or is_dead or not can_attack:
		return

	is_attacking = true
	can_attack = false

	var attack_anim = "attack_left" if flip_left else "attack_right"
	anim_player.play(attack_anim)
	await anim_player.animation_finished

	is_attacking = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


func move_towards(target_position: Vector2) -> void:
	if is_dead or is_attacking:
		return

	var to_target = target_position - global_position
	direction = Vector2(sign(to_target.x), 0)  # Clamp to horizontal
	velocity = to_target.normalized() * speed
