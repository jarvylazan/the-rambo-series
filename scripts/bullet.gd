extends Area2D
# Basic bullet script - attach this to your bullet scene
var velocity = Vector2.ZERO
var speed = 500
@onready var particles = %BulletExplosionGPUParticles2D

func _ready():
	# Auto-remove after 10 seconds if it hasn't hit anything
	var timer = Timer.new()
	timer.wait_time = 10.0
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", _on_lifetime_timeout)
	add_child(timer)
	
	# Make sure these signals are connected
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)

func _physics_process(delta):
	# Use continuous collision detection to prevent tunneling
	var space_state = get_world_2d().direct_space_state
	var start_position = global_position
	var end_position = global_position + velocity * delta
	
	var query = PhysicsRayQueryParameters2D.create(start_position, end_position)
	query.collision_mask = collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	
	if result:
		# Handle collision
		if result.collider.is_in_group("enemy"):
			result.collider.take_gun_damage()
			queue_free()
			return
		elif result.collider.is_in_group("Environment") or result.collider is TileMap:
			queue_free()
			return
	
	# Move the bullet if no collision was detected
	position += velocity * delta

# Initialize bullet movement
func init(direction, bullet_speed):
	velocity = direction * bullet_speed
	
	# Rotate the bullet to face the direction of travel
	rotation = direction.angle()

# Auto-remove when lifetime expires
func _on_lifetime_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_gun_damage()
		queue_free()
	elif body.is_in_group("Environment") or body is TileMap:
		# Any blocking tilemap
		queue_free()

# Add support for enemy that might be an Area2D instead of a Body
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.take_gun_damage()
		queue_free()

func _on_tree_exiting() -> void:
	if particles:
		# Store current global position before removing
		var position_to_spawn = global_position
		
		# Remove the particles from this node and add to root
		var parent = particles.get_parent()
		parent.remove_child(particles)
		get_tree().root.add_child(particles)
		
		# Set the particles to the stored position
		particles.global_position = position_to_spawn
		
		# Enable emission
		particles.emitting = true
		particles.one_shot = true
		
		# Optional: Add a timer to automatically free the particles after they finish
		var timer = Timer.new()
		timer.wait_time = particles.lifetime
		timer.one_shot = true
		timer.autostart = true
		particles.add_child(timer)
		timer.timeout.connect(func(): particles.queue_free())
