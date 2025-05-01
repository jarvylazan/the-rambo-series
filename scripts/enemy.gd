extends CharacterBody2D
class_name Enemy

@export var speed: float = 50.0
@export var health: int = 100
@export var max_health: int = 100
@export var damage: int = 10
@export var attack_range: float = 50.0

var is_attacking := false
var is_dead := false
var is_hurt := false
var direction := Vector2.LEFT

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO  # Stop movement on collision
	update_animation()

func update_animation() -> void:
	if is_dead:
		anim.play("die")
	elif is_hurt:
		anim.play("hurt")
	elif is_attacking:
		anim.play("attack")
	elif velocity.length() > 1:
		anim.play("run")
	else:
		anim.play("idle")

	anim.flip_h = direction.x > 0

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

func attack() -> void:
	if is_attacking or is_dead:
		return

	is_attacking = true
	anim.play("attack")
	await anim.animation_finished
	is_attacking = false

func move_towards(target_position: Vector2) -> void:
	if is_dead or is_attacking:
		return

	var to_target = (target_position - global_position).normalized()
	direction = to_target
	velocity = to_target * speed
