extends Node

func _ready():
	$MenuUi/Version.text = "ver. " + str(ProjectSettings.get_setting("application/config/version"))

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$StartingTimer.start()
		$AnimationPlayer.play("starting")

func _on_starting_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
