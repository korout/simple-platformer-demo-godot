extends Area2D

func _ready() -> void:
	animate()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.coin += randi_range(1, 4)
		$"/root/CoinSfx".play()
		queue_free()

func animate() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite2D, "position", Vector2(0, 2), 0.2)
	tween.tween_property($Sprite2D, "position", Vector2(0, 0), 0.2)
	await get_tree().create_timer(0.4).timeout
	animate()
