extends Area2D
@export var item: InvItem

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player"):

		# Register key before it's lost
		if item.key_id != "" and not Global.collected_keys.has(item.key_id):
			Global.collected_keys.append(item.key_id)
			print("Collected key:", item.key_id)

		body.collect(item)
		queue_free()
