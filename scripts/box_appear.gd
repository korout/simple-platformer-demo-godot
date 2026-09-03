extends StaticBody2D

var appear: bool

@export var start_time := 1.0
@export var appear_time := 1.0

func _ready() -> void:
	await get_tree().create_timer(start_time).timeout
	_starting()

func _physics_process(delta: float) -> void:
	$Sprite2D.visible = appear
	$CollisionShape2D.disabled = not appear

func _starting() -> void:
	await get_tree().create_timer(appear_time).timeout
	_appear()

func _appear() -> void:
	appear = not appear
	if appear: $AudioStreamPlayer2D.play()
	_starting()
