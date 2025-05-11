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
var boosted := false
var boost_timer: Timer = null
var base_spear_damage := 30
var base_gun_damage := 10
@onready var inv: Inv = preload("res://inventory/player_inv.tres") 


func _ready():
	var saved = load("res://inventory/player_inv.tres") as Resource
	inv.slots = saved.slots.duplicate(true)

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
# === DAMAGE SYSTEM FOR WEAPONS ===

func get_spear_damage() -> int:
	return base_spear_damage * (100 if boosted else 1)

func get_gun_damage() -> int:
	return base_gun_damage * (100 if boosted else 1)
	
func apply_power_boost():
	if boosted:
		return  # Already boosted, don't stack

	boosted = true
	print(" Power boost activated!")

	if boost_timer:
		boost_timer.queue_free()

	boost_timer = Timer.new()
	boost_timer.wait_time = 10  # Boost duration in seconds
	boost_timer.one_shot = true
	boost_timer.timeout.connect(_on_boost_timeout)
	add_child(boost_timer)
	boost_timer.start()

func _on_boost_timeout():
	boosted = false
	boost_timer.queue_free()
	boost_timer = null
	print("Power boost ended.")
	
	
func _input(event):
	if  event.is_action_pressed("ui_cancel") and pause_menu:
		if  pause_menu.visible:
			pause_menu.hide_pause_menu()
		else:
			pause_menu.show_pause_menu()
