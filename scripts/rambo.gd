extends CharacterBody2D
@export var speed = 300.0  # Movement speed in pixels per second
@export var acceleration = 1500.0  # How fast the character accelerates
@export var friction = 1500.0  # How fast the character slows down
var facing_direction = "down"
var is_moving = false
var is_attacking = false

func _physics_process(delta):
	# Handle attack input first
	if Input.is_action_just_pressed("Melee") and not is_attacking:
		is_attacking = true
		play_attack_animation()
		# You may want to add a timer to reset is_attacking after animation finishes
		await get_tree().create_timer(0.5).timeout
		is_attacking = false
		return # Skip movement during attack animation
		
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	# Normalize the input direction if it's greater than 1
	if input_direction.length() > 1.0:
		input_direction = input_direction.normalized()
	
	# Check if character is moving
	is_moving = input_direction != Vector2.ZERO
	
	# Handle acceleration and deceleration
	if is_moving:
		# Accelerate when there's input
		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
		
		# Update facing direction and animation
		update_facing_direction(input_direction)
	else:
		# Apply friction when there's no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		# Switch to idle animation when not moving
		play_idle_animation()
	
	# Move the character
	move_and_slide()
	
func update_facing_direction(direction):
	# Skip animation updates if attacking
	if is_attacking:
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
	# Skip animation updates if attacking
	if is_attacking:
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

func play_attack_animation():
	# Play attack animation based on current facing direction
	match facing_direction:
		"right":
			%RamboAnimatedSprite2D.play("spearright")
		"left":
			%RamboAnimatedSprite2D.play("spearleft")
		"down":
			%RamboAnimatedSprite2D.play("speardown")
		"up":
			%RamboAnimatedSprite2D.play("spearup")
		"top_right":
			%RamboAnimatedSprite2D.play("spearupright")
		"top_left":
			%RamboAnimatedSprite2D.play("spearupleft")
		"bottom_right":
			%RamboAnimatedSprite2D.play("spearright")
		"bottom_left":
			%RamboAnimatedSprite2D.play("spearleft")
			
	# Make sure scale is consistent
	%RamboAnimatedSprite2D.scale = Vector2(15, 15)
