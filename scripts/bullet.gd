extends Area2D
# Basic bullet script - attach this to your bullet scene

var velocity = Vector2.ZERO
var speed = 500

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
