extends Node2D

var enemy_count := 0

func _ready() -> void:
	Global.pause_menu = $PauseMenu

func _physics_process(delta):
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()
	
	print("Current enemy count: " + str(enemy_count))
	
	if enemy_count == 0:
		print("All enemies defeated!")
