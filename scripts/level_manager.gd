extends Node

@export var player : CharacterBody2D
@export var ui : CanvasLayer

var win: bool
var over: bool

@export var change_level: String

func _ready():
	get_tree().paused = false

func _physics_process(delta):
	if Input.is_action_just_released("pause") and not over and not win:
		get_tree().paused = true
		ui.get_node("Pause/PauseMenuAnimation").speed_scale = 1
		ui.get_node("Pause/PauseMenuAnimation").play("new_animation")
		$"/root/DetSfx".play()
	
	if over and $Los.is_stopped():
		$"/root/DamageSfx".play()
		$Los.start()
	
	if win:
		player.velocity = Vector2(0, 0)
		player.scale = lerp(player.scale, Vector2(0, 0), 0.1)
		player.global_position = lerp(player.global_position, $WinArea.global_position, 0.1)
		player.perform_jump = false

func _on_pm_play_pressed():
	get_tree().paused = false
	ui.get_node("Pause/PauseMenuAnimation").play("res")
	$"/root/DetSfx".play()

func _on_reset_pressed():
	$"/root/DetSfx".play()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_los_timeout():
	if win: get_tree().change_scene_to_file(change_level)
	if over: get_tree().reload_current_scene()

func _on_win_area_body_entered(body):
	if body.name == "Player":
		win = true
		ui.get_node("Complete").show()
		ui.get_node("Complete/CompleteAnimation").play("new_animation")
		$"/root/Success".play()
		$Los.wait_time = 4
		$Los.start()
