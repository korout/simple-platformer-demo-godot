extends Node

@onready var player: CharacterBody2D = $"../Player"
@onready var ui: CanvasLayer = $"../Ui"

var win: bool
var over: bool

@export var change_level: String

func _ready() -> void:
	get_tree().paused = false

func _physics_process(delta: float) -> void:
	if win:
		player.body.play("idle")
		player.velocity = Vector2(0, 0)
		player.global_position = lerp(player.global_position, $WinArea.global_position, 0.1)
		player.jump_active = false

func _on_win_area_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	if body.name == "Player":
		tween.tween_property($WinArea/Flag, "position", Vector2(0, -12), 0.6)
		win = true
		$"/root/Success".play()
		game_timeout()

func game_timeout() -> void:
	await get_tree().create_timer(5.0).timeout
	if win: get_tree().change_scene_to_file(change_level)
	if over: get_tree().reload_current_scene()

func _on_player_ui_coin_signal(coin) -> void:
	ui.get_node("Game/CoinLabel").text = str(coin)
