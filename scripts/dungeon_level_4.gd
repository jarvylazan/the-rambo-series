extends Node2D
var enemy_count := 0
var enemy_count_label  # Will properly initialize this in _ready

func _ready() -> void:
	Global.pause_menu = $PauseMenu
	
	Global.level_tracker = 4
	
	# Get the EnemyCountLabel from the group
	enemy_count_label = get_tree().get_first_node_in_group("enemy_count")

func _physics_process(delta):  # Fixed function name with underscores
	var previous_enemy_count = enemy_count
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()
	
	# Set text instead of appending with +=
	if enemy_count_label and previous_enemy_count != enemy_count:
		enemy_count_label.text = "ENEMIES_REMAINING: " + str(enemy_count)
	
	print("Current enemy count: " + str(enemy_count))
	
	if enemy_count == 0:
		print("All enemies defeated!")
