extends Node

@export var player : CharacterBody2D
@export var ui : CanvasLayer

var win: bool
var over: bool

@export var change_level: String

func _ready():
	get_tree().paused = false

func _physics_process(delta):
	var tween = create_tween()
	if Input.is_action_just_released("pause") and not over and not win:
		get_tree().paused = true
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(ui.get_node("Pause"), "position", Vector2(0, 0), 0.2)
		$"/root/PressSfx".play()
	
	if win:
		player.velocity = Vector2(0, 0)
		player.scale = lerp(player.scale, Vector2(0, 0), 0.1)
		player.global_position = lerp(player.global_position, $WinArea.global_position, 0.1)
		player.perform_jump = false

func _on_pm_play_pressed():
	var tween = create_tween()
	get_tree().paused = false
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(ui.get_node("Pause"), "position", Vector2(0, 180), 0.1)
	$"/root/PressSfx".play()

func _on_reset_pressed():
	$"/root/PressSfx".play()
	get_tree().paused = false
	get_tree().reload_current_scene()
	if win: get_tree().change_scene_to_file(change_level)
	if over: get_tree().reload_current_scene()

func _on_win_area_body_entered(body):
	if body.name == "Player":
		win = true
		ui.get_node("Complete").show()
		ui.get_node("Complete/CompleteAnimation").play("new_animation")
		$"/root/Success".play()
		game_timeout()

func game_timeout():
	await get_tree().create_timer(4.0).timeout
	if win: get_tree().change_scene_to_file(change_level)
	if over: get_tree().reload_current_scene()
