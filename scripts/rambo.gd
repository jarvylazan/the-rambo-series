extends CharacterBody2D

@export var speed = 300.0  # Movement speed in pixels per second
@export var acceleration = 2000.0  # How fast the character accelerates
@export var friction = 2000.0  # How fast the character slows down

var facing_direction = "down"
var is_moving = false

func _physics_process(delta):
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
	# Check for diagonal movement first
	if abs(direction.x) > 0.3 and abs(direction.y) > 0.3:
		# Handle diagonal directions
		if direction.x > 0 and direction.y < 0:
			facing_direction = "top_right"
			%RamboAnimatedSprite2D.play("runtopleft")
			%RamboAnimatedSprite2D.scale = Vector2(-0.30, 0.30)
		elif direction.x < 0 and direction.y < 0:
			facing_direction = "top_left"
			%RamboAnimatedSprite2D.play("runtopleft")
			%RamboAnimatedSprite2D.scale = Vector2(0.30, 0.30)
		elif direction.x > 0 and direction.y > 0:
			facing_direction = "bottom_right"
			%RamboAnimatedSprite2D.play("rundownleft")
			%RamboAnimatedSprite2D.scale = Vector2(-0.30, 0.30)
		elif direction.x < 0 and direction.y > 0:
			facing_direction = "bottom_left"
			%RamboAnimatedSprite2D.play("rundownleft")
			%RamboAnimatedSprite2D.scale = Vector2(0.30, 0.30)
	elif abs(direction.x) > abs(direction.y):
		# Horizontal movement is dominant
		if direction.x > 0:
			facing_direction = "right"
			%RamboAnimatedSprite2D.play("runsideways")
			%RamboAnimatedSprite2D.scale = Vector2(-0.30, 0.30)
		else:
			facing_direction = "left"
			%RamboAnimatedSprite2D.play("runsideways")
			%RamboAnimatedSprite2D.scale = Vector2(0.30, 0.30)
	else:
		# Vertical movement is dominant
		if direction.y > 0:
			facing_direction = "down"
			%RamboAnimatedSprite2D.play("rundown")
			%RamboAnimatedSprite2D.scale = Vector2(0.30, 0.30)
		else:
			facing_direction = "up"
			%RamboAnimatedSprite2D.play("runup")
			%RamboAnimatedSprite2D.scale = Vector2(0.27, 0.27)

func play_idle_animation():
	# Switch to idle animation and apply proper scaling
	%RamboAnimatedSprite2D.play("idle")
	
	# Keep the correct facing direction with proper scaling
	match facing_direction:
		"right", "top_right", "bottom_right":
			%RamboAnimatedSprite2D.scale = Vector2(-1.0, 1.0)  # Flipped horizontally
		"left", "top_left", "bottom_left":
			%RamboAnimatedSprite2D.scale = Vector2(1.0, 1.0)   # Normal orientation
		"down", "up":
			# Add specific handling for up/down idle if needed
			%RamboAnimatedSprite2D.scale = Vector2(1.0, 1.0)
