extends Node
var health:= 79
const MIN_HEALTH := 0
const MAX_HEALTH := 79
const HEALTH_INCREMENT := 0.71
signal health_changed(new_health)
signal took_damage
signal die
var counter := 0
var can_shoot = false
var bullet_count := 0
var pause_menu: Node = null

func take_damage(percentage):
	counter += 1
	var damage = MAX_HEALTH * (percentage / 100.0)
	health = max(health - damage, MIN_HEALTH)
	emit_signal("health_changed", health)
	emit_signal("took_damage")
	print("Current Health: ", health)
	print("Damage taken: ", damage)
	print("Counter: ", counter)
	if health <= MIN_HEALTH:
		MusicManager.stop_music()
		await emit_signal("die")
		await get_tree().create_timer(1.6).timeout 

		SceneManager.change_scene("res://scenes/game_over.tscn", {
			"pattern": "fade"
		})

func heal(percentage):
	var healing_done = MAX_HEALTH * (percentage / 100.0)
	health = min(health + healing_done, MAX_HEALTH)
	emit_signal("health_changed", health)

func modify_shoot_state(state):
	can_shoot = state
	
	
func _input(event):
	if  event.is_action_pressed("ui_cancel") and pause_menu:
		if  pause_menu.visible:
			pause_menu.hide_pause_menu()
		else:
			pause_menu.show_pause_menu()
