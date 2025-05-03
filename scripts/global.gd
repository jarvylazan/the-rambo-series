extends Node
var health:= 79
const MIN_HEALTH := 0
const MAX_HEALTH := 79
const HEALTH_INCREMENT := 0.71
signal health_changed(new_health)
signal took_damage
var counter := 0

func take_damage(percentage):
	counter += 1
	var damage = MAX_HEALTH * (percentage / 100.0)
	health = max(health - damage, MIN_HEALTH)
	emit_signal("health_changed", health)
	emit_signal("took_damage")
	print(health)
	print("Damage taken: ", damage)
	print("Counter: ", counter)
	if health <= MIN_HEALTH:
		SceneManager.change_scene("res://scenes/game_over.tscn", {
			"pattern": "fade"
		})

func heal(percentage):
	var healing_done = MAX_HEALTH * (percentage / 100.0)
	health = min(health + healing_done, MAX_HEALTH)
	emit_signal("health_changed", health)
