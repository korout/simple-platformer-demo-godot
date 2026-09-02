extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		get_tree().paused = not get_tree().paused
		$"/root/PressSfx".play()
