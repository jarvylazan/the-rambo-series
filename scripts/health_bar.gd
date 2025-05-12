extends Control

var tween

func _ready() -> void:
	%TextureProgressBar.value = Global.health
	%BulletsLabel.text = str(Global.bullet_count)
	%CoinsLabel.text = str(Global.coin_count)
	Global.health_changed.connect(_on_health_changed)

func _on_health_changed(new_health: float) -> void:
	if tween:  # Stop any existing tween
		tween.kill()

	tween = create_tween()
	tween.tween_property(
		%TextureProgressBar,
		"value",
		new_health,
		0.4  # duratsion in seconds
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func update_coins(amount: int) -> void:
	%CoinsLabel.text = str(amount)
	
	
func update_ammo(amount: int) -> void:
	%BulletsLabel.text = str(amount)
