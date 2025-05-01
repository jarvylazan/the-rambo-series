extends Area2D

@export var item: InvItem

var player = null

func _on_body_entered(body):
	player = body
	player.collect(item)
	queue_free()
