extends CharacterBody2D
@export var speed = 300.0  # Movement speed in pixels per second
@export var acceleration = 1500.0  # How fast the character accelerates
@export var friction = 1500.0  # How fast the character slows down
var facing_direction = "down"
var is_moving = false
var is_attacking = false
var is_shooting = false
var attack_animation_priority = true  # This gives attack animations priority

func get_animation_duration(animation_name: String) -> float:
	# Get the frame count
	var frame_count = %RamboAnimatedSprite2D.sprite_frames.get_frame_count(animation_name)
	
	# Get the frame rate (frames per second)
	var fps = %RamboAnimatedSprite2D.sprite_frames.get_animation_speed(animation_name)
	
	# Calculate duration in seconds
	var duration = frame_count / float(fps)
	
	return duration

func _physics_process(delta):
	# Handle attack inputs first, prioritizing shooting over melee if both pressed simultaneously
	if Input.is_action_just_pressed("Shoot") and not is_attacking and not is_shooting:
		is_shooting = true
		var anim_name = play_shoot_animation()
		
		# Use the duration of the animation for the timer
		var duration = get_animation_duration(anim_name)
		await get_tree().create_timer(duration).timeout
		is_shooting = false
	elif Input.is_action_just_pressed("Melee") and not is_attacking and not is_shooting:
		is_attacking = true
		var anim_name = play_attack_animation()
		
		# Use the duration of the animation for the timer
		var duration = get_animation_duration(anim_name)
		await get_tree().create_timer(duration).timeout
		is_attacking = false
		
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
		var current_speed = speed * (0.35 if (is_attacking or is_shooting) else 1.0)  # Reduced speed during actions
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
	if (is_attacking or is_shooting) and attack_animation_priority:
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
		"left":
			anim_name = "spearleft"
		"down":
			anim_name = "speardown"
		"up":
			anim_name = "spearup"
		"top_right":
			anim_name = "spearupright"
		"top_left":
			anim_name = "spearupleft"
		"bottom_right":
			anim_name = "speardownright"
		"bottom_left":
			anim_name = "speardownleft"
			
	# Play the animation
	%RamboAnimatedSprite2D.play(anim_name)
	
	# Make sure scale is consistent
	%RamboAnimatedSprite2D.scale = Vector2(15, 15)
	
	# Return the animation name so we can get its duration
	return anim_name

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
