extends Area2D
@export var item: InvItem

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.collect(item)
		queue_free()
