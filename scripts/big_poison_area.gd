extends Area2D

@export var damage_per_second := 5
@export var damage_interval := 1.0

var player_in_area := false
var timer := 0.0
var affected_player = null

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta):
	if player_in_area and affected_player:
		timer += delta
		if timer >= damage_interval:
			timer = 0.0
			if Global.health > 0:
				Global.take_damage(damage_per_second)
				print("Player took poison damage!")

				# Make the player blink purple
				if affected_player.has_method("start_poison_blink"):
					affected_player.start_poison_blink(2.0)  # Blink for 2 seconds


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	player_in_area = true
	timer = 0.0
	affected_player = body

func _on_body_exited(body):
	if not body.is_in_group("player"):
		return

	player_in_area = false
	affected_player = null
