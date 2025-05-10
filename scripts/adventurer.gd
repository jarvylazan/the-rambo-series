extends CharacterBody2D
@export var speed = 300.0  # Movement speed in pixels per second
@export var acceleration = 1500.0  # How fast the character accelerates
@export var friction = 1500.0  # How fast the character slows down
@export_file("*.tscn") var bullet_scene_path = "res://scenes/bullet.tscn"  # Exported path for easier editing
@export var inv: Inv

var hud


var coin_count: int = 0
var bullet_count: int = 0

var facing_direction = "down"
var is_moving = false
var is_attacking = false
var is_shooting = false
var attack_animation_priority = true  # This gives attack animations priority
var shoot_timer = null  # Timer reference for shooting
var bullet_timer = null  # Timer for spawning bullets
var bullet_scene = null  # Will load at runtime
var bullet_speed = 5000  # How fast bullets travel
var shoot_cooldown = 0.2
var is_dead = false
var can_move := true  # Used to freeze/unfreeze player movement

func get_animation_duration(animation_name: String) -> float:
	# Get the frame count
	var frame_count = %RamboAnimatedSprite2D.sprite_frames.get_frame_count(animation_name)
	
	# Get the frame rate (frames per second)
	var fps = %RamboAnimatedSprite2D.sprite_frames.get_animation_speed(animation_name)
	
	# Calculate duration in seconds
	var duration = frame_count / float(fps)
	
	return duration

func _ready():
	call_deferred("_get_hud")
	# Load the bullet scene at runtime instead of preloading
	bullet_scene = load(bullet_scene_path)
	if not bullet_scene:
		push_error("Failed to load bullet scene from path: " + bullet_scene_path)
	
	# Create a shooting timer that we can cancel
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# Create bullet spawning timer
	bullet_timer = Timer.new()
	bullet_timer.wait_time = shoot_cooldown
	bullet_timer.one_shot = false
	add_child(bullet_timer)
	bullet_timer.timeout.connect(_on_bullet_timer_timeout)
	Global.die.connect(_on_player_die)
	
func _get_hud():
	hud = get_node("Hud")

func _on_shoot_timer_timeout():
	
	# If player is still holding the shoot batton, restart the animation
	if Input.is_action_pressed("Shoot") and Global.can_shoot:
		var input_direction = Vector2(
			Input.get_action_strength("Right") - Input.get_action_strength("Left"),
			Input.get_action_strength("Down") - Input.get_action_strength("Up")
		)
		
		var anim_name = ""
		if is_moving:
			anim_name = play_run_and_gun_animation(input_direction)
		else:
			anim_name = play_shoot_animation()
			
		var duration = get_animation_duration(anim_name)
		shoot_timer.start(duration)
	else:
		# Only stop shooting if the player released the button
		is_shooting = false
		bullet_timer.stop()

func _on_bullet_timer_timeout():
	# Spawn a bullet
	if Global.can_shoot:
		spawn_bullet()



func spawn_bullet():
	
	if is_dead:
		return
	
	# Skip if bullet scene isn't loaded
	if not bullet_scene:
		push_error("Bullet scene not loaded. Cannot spawn bullet.")
		return
		
		
	Global.bullet_count -= 1
	hud.update_ammo(Global.bullet_count)

	# Create instance of bullet
	var bullet = bullet_scene.instantiate()
	
	# Add bullet to the scene first (important for setting node properties)
	get_parent().add_child(bullet)
	
	# Get bullet spawn position with an offset from player center
	var spawn_offset = Vector2.ZERO
	match facing_direction:
		"right":
			spawn_offset = Vector2(40, 0)
		"left":
			spawn_offset = Vector2(-40, 0)
		"down":
			spawn_offset = Vector2(0, 40)
		"up":
			spawn_offset = Vector2(0, -40)
		"top_right":
			spawn_offset = Vector2(30, -30)
		"top_left":
			spawn_offset = Vector2(-30, -30)
		"bottom_right":
			spawn_offset = Vector2(30, 30)
		"bottom_left":
			spawn_offset = Vector2(-30, 30)
	
	# Set the bullet's position to start at the character with offset
	bullet.global_position = global_position + spawn_offset
	
	# Set the bullet's direction based on facing direction
	var direction = Vector2.ZERO
	match facing_direction:
		"right":
			direction = Vector2(1, 0)
		"left":
			direction = Vector2(-1, 0)
		"down":
			direction = Vector2(0, 1)
		"up":
			direction = Vector2(0, -1)
		"top_right":
			direction = Vector2(1, -1).normalized()
		"top_left":
			direction = Vector2(-1, -1).normalized()
		"bottom_right":
			direction = Vector2(1, 1).normalized()
		"bottom_left":
			direction = Vector2(-1, 1).normalized()
	
	# Try multiple approaches to set bullet properties
	
	# Approach 1: Use init method if available
	if bullet.has_method("init"):
		bullet.init(direction, bullet_speed)
	
	# Approach 2: Set linear_velocity if it's a RigidBody2D
	elif bullet is RigidBody2D:
		bullet.linear_velocity = direction * bullet_speed
	
	# Approach 3: Set velocity if it's a CharacterBody2D
	elif bullet is CharacterBody2D:
		bullet.velocity = direction * bullet_speed
	
	# Approach 4: Set basic properties directly
	else:
		if "direction" in bullet:
			bullet.direction = direction
		if "speed" in bullet:
			bullet.speed = bullet_speed
		if "velocity" in bullet:
			bullet.velocity = direction * bullet_speed
	
	# Make sure bullet is visible
	if bullet.has_node("Sprite2D"):
		var sprite = bullet.get_node("Sprite2D")
		sprite.visible = true
	elif bullet.has_node("AnimatedSprite2D"):
		var sprite = bullet.get_node("AnimatedSprite2D")
		sprite.visible = true
		sprite.play()
	
	# Print debug info to console
	print("Bullet spawned at position: ", bullet.global_position)
	print("Bullet direction: ", direction)

func _physics_process(delta):
	
	if Global.bullet_count == 0:
		Global.modify_shoot_state(false)
	elif Global.bullet_count > 0:
		Global.modify_shoot_state(true)
	
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Manual unfreeze during testing (press U key)
	if Input.is_action_just_pressed("unfreeze_player"):
		can_move = true

	# Freeze player if needed (used for when dialogue appears in the tutorial level)
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Get input direction (we need this before handling attacks to determine run-and-gun animations)
	var input_direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	
	# Normalize the input direction if it's greater than 1
	if input_direction.length() > 1.0:
		input_direction = input_direction.normalized()

	
	# Check if character is moving
	is_moving = input_direction != Vector2.ZERO
	
	# Update facing direction if moving
	if is_moving:
		update_facing_direction_no_animation(input_direction)
		
		# If currently shooting, update the run-and-gun animation to match new direction
		if is_shooting:
			play_run_and_gun_animation(input_direction)
	
	# Check if shoot button was just pressed or if it's still being held
	if Input.is_action_just_pressed("Shoot") and not is_attacking and not is_shooting and Global.can_shoot:
		is_shooting = true
		var anim_name = ""
		
		# Use run-and-gun animations if moving
		if is_moving:
			anim_name = play_run_and_gun_animation(input_direction)
		else:
			anim_name = play_shoot_animation()
		
		# Start the timer for animation loop if button is held
		var duration = get_animation_duration(anim_name)
		shoot_timer.start(duration)
		
		# Start spawning bullets
		bullet_timer.start()
		spawn_bullet()  # Spawn first bullet immediately
	
	# Check if shoot button was released (cancel shooting)
	if Input.is_action_just_released("Shoot") and is_shooting:
		is_shooting = false
		shoot_timer.stop()  # Stop the timer
		bullet_timer.stop()  # Stop spawning bullets
	
	# Handle melee attack
	if Input.is_action_just_pressed("Melee") and not is_attacking and not is_shooting:
		is_attacking = true
		var anim_name = play_attack_animation()
		
		# Use the duration of the animation for the timer
		var duration = get_animation_duration(anim_name)
		await get_tree().create_timer(duration).timeout
		is_attacking = false
	
	# Handle acceleration and deceleration
	if is_moving:
		# Accelerate when there's input
		var current_speed = speed
		# Only slow down for melee attacks, not for shooting
		if is_attacking:
			current_speed *= 0.35
		
		velocity = velocity.move_toward(input_direction * current_speed, acceleration * delta)
		
		# Update facing direction and animations only if not in an action
		if not (is_attacking or is_shooting) or not attack_animation_priority:
			update_facing_direction(input_direction)
	else:
		# Apply friction when there's no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		# Switch to idle animation when not moving and not in an action
		if not (is_attacking or is_shooting) or not attack_animation_priority:
			play_idle_animation()
	
	# Move the character
	move_and_slide()

# Updates facing direction without changing animation
func update_facing_direction_no_animation(direction):
	# Check for diagonal movement first
	if abs(direction.x) > 0.3 and abs(direction.y) > 0.3:
		# Handle diagonal directions
		if direction.x > 0 and direction.y < 0:
			facing_direction = "top_right"
		elif direction.x < 0 and direction.y < 0:
			facing_direction = "top_left"
		elif direction.x > 0 and direction.y > 0:
			facing_direction = "bottom_right"
		elif direction.x < 0 and direction.y > 0:
			facing_direction = "bottom_left"
	elif abs(direction.x) > abs(direction.y):
		# Horizontal movement is dominant
		if direction.x > 0:
			facing_direction = "right"
		else:
			facing_direction = "left"
	else:
		# Vertical movement is dominant
		if direction.y > 0:
			facing_direction = "down"
		else:
			facing_direction = "up"
	
func update_facing_direction(direction):
	# Skip animation updates if in an action with priority
	if (is_attacking or is_shooting) and attack_animation_priority:
		return
		
	# Check for diagonal movement first
	if abs(direction.x) > 0.3 and abs(direction.y) > 0.3:
		# Handle diagonal directions
		if direction.x > 0 and direction.y < 0:
			facing_direction = "top_right"
			%RamboAnimatedSprite2D.play("runtopleft")
			%RamboAnimatedSprite2D.scale = Vector2(-15, 15)
		elif direction.x < 0 and direction.y < 0:
			facing_direction = "top_left"
			%RamboAnimatedSprite2D.play("runtopleft")
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
		elif direction.x > 0 and direction.y > 0:
			facing_direction = "bottom_right"
			%RamboAnimatedSprite2D.play("rundownleft")
			%RamboAnimatedSprite2D.scale = Vector2(-15, 15)
		elif direction.x < 0 and direction.y > 0:
			facing_direction = "bottom_left"
			%RamboAnimatedSprite2D.play("rundownleft")
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	elif abs(direction.x) > abs(direction.y):
		# Horizontal movement is dominant
		if direction.x > 0:
			facing_direction = "right"
			%RamboAnimatedSprite2D.play("runsideways")
			%RamboAnimatedSprite2D.scale = Vector2(-15, 15)
		else:
			facing_direction = "left"
			%RamboAnimatedSprite2D.play("runsideways")
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	else:
		# Vertical movement is dominant
		if direction.y > 0:
			facing_direction = "down"
			%RamboAnimatedSprite2D.play("rundown")
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
		else:
			facing_direction = "up"
			%RamboAnimatedSprite2D.play("runup")
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
			
func play_idle_animation():
	# Skip animation updates if in an action with priority
	if (is_attacking or is_shooting) and attack_animation_priority or is_dead:
		return
		
	# Match the correct animation based on facing direction
	match facing_direction:
		"right":
			%RamboAnimatedSprite2D.play("idleright")
		"left":
			%RamboAnimatedSprite2D.play("idleleft")
		"down":
			%RamboAnimatedSprite2D.play("idledown")
		"up":
			%RamboAnimatedSprite2D.play("idleup")
		"top_right":
			%RamboAnimatedSprite2D.play("idleupright")
		"top_left":
			%RamboAnimatedSprite2D.play("idleupleft")
		"bottom_right":
			%RamboAnimatedSprite2D.play("idleright")
		"bottom_left":
			%RamboAnimatedSprite2D.play("idleleft")
	
	# Make sure scale is consistent
	%RamboAnimatedSprite2D.scale = Vector2(15, 15)

func play_attack_animation() -> String:
	# Variable to store animation name
	var anim_name = ""
	
	# Determine attack animation based on current facing direction
	match facing_direction:
		"right":
			anim_name = "spearright"
			%RamboAnimationPlayer.play("spearright")
		"left":
			anim_name = "spearleft"
			%RamboAnimationPlayer.play("spearleft")
		"down":
			anim_name = "speardown"
			%RamboAnimationPlayer.play("speardown")
		"up":
			anim_name = "spearup"
			%RamboAnimationPlayer.play("spearup")

		"top_right":
			anim_name = "spearupright"
			%RamboAnimationPlayer.play("spearupright")
		"top_left":
			anim_name = "spearupleft"
			%RamboAnimationPlayer.play("spearupleft")
		"bottom_right":
			anim_name = "speardownright"
			%RamboAnimationPlayer.play("speardownright")
		"bottom_left":
			anim_name = "speardownleft"
			%RamboAnimationPlayer.play("speardownleft")
			
	# Play the animation
	%RamboAnimatedSprite2D.play(anim_name)
	
	# Make sure scale is consistent
	%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	
	# Return the animation name so we can get its duration
	return anim_name
	
func attack_finished():
	%RamboAnimationPlayer.play("RESET")

func play_shoot_animation() -> String:
	# Variable to store animation name
	var anim_name = ""
	
	# Determine shoot animation based on current facing direction
	match facing_direction:
		"right":
			anim_name = "gunright"
		"left":
			anim_name = "gunleft"
		"down":
			anim_name = "gundown"
		"up":
			anim_name = "gunup"
		"top_right":
			anim_name = "gunupright"
		"top_left":
			anim_name = "gunupleft"
		"bottom_right":
			anim_name = "gundownright"
		"bottom_left":
			anim_name = "gundownleft"
			
	# Play the animation
	%RamboAnimatedSprite2D.play(anim_name)
	
	# Make sure scale is consistent
	%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	
	# Return the animation name so we can get its duration
	return anim_name

func collect(item):
	inv.insert(item)

	match item.name:
		"coins":
			coin_count += 10
			hud.update_coins(coin_count)
		"ammo":
			Global.bullet_count += 20
			hud.update_ammo(Global.bullet_count)
		# Don't auto-use potion here anymore

		"red_potion":
			Global.heal(30)
		"yellow_potion":
			Global.heal(100)
		


func play_run_and_gun_animation(direction) -> String:
	# Variable to store animation name
	var anim_name = ""
	
	# Determine run-and-gun animation based on movement direction
	if abs(direction.x) > 0.3 and abs(direction.y) > 0.3:
		# Handle diagonal directions
		if direction.x > 0 and direction.y < 0:
			anim_name = "agunrunupright"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)  # Using consistent scale
		elif direction.x < 0 and direction.y < 0:
			anim_name = "agunrunupleft"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
		elif direction.x > 0 and direction.y > 0:
			anim_name = "agunrundownright"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
		elif direction.x < 0 and direction.y > 0:
			anim_name = "agunrundownleft"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	elif abs(direction.x) > abs(direction.y):
		# Horizontal movement is dominant
		if direction.x > 0:
			anim_name = "agunrunright"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
		else:
			anim_name = "agunrunleft"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	else:
		# Vertical movement is dominant
		if direction.y > 0:
			anim_name = "agunrundown"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
		else:
			anim_name = "agunrunup"
			%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	
	# Play the animation
	%RamboAnimatedSprite2D.play(anim_name)
	
	# Return the animation name so we can get its duration
	return anim_name

func _on_player_die():
	is_dead = true
	can_move = false
	velocity = Vector2.ZERO
	play_death_animation()

func play_death_animation():
	%RamboAnimatedSprite2D.play("die")
	
	await %RamboAnimatedSprite2D.animation_finished


func _on_spear_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body is Enemy:
		var enemy := body as Enemy
		enemy.take_spear_damage()
