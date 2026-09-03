extends Node

func _ready() -> void:
	get_tree().paused = false
	$MenuUi/Version.text = "ver. " + str(ProjectSettings.get_setting("application/config/version"))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		$"/root/PressSfx".play()
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
