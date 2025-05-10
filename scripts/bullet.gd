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

func _process(delta):
	# Move the bullet
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
	elif body.is_in_group("Environment") or body is TileMap:
		# Any blocking tilemap
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
		timer.wait_time = particles.lifetime + 0.5 # Add a small buffer
		timer.one_shot = true
		timer.autostart = true
		particles.add_child(timer)
		timer.timeout.connect(func(): particles.queue_free())
