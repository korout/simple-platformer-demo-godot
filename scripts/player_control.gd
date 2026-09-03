extends CharacterBody2D

const SPEED = 110.0
const JUMP_VELOCITY = -280.0

var perform_jump: bool

var health: int = 100
var coin: int

@onready var level_mgr: Node = $"../LevelManager"

@onready var body: AnimatedSprite2D = $Body
@onready var collision: CollisionShape2D = $Coll

signal ui_coin_signal

func _physics_process(delta: float) -> void:
	var tween = create_tween()
	
	if not level_mgr.over and not level_mgr.win:
		velocity.x = SPEED * Input.get_axis("left", "right")
		if velocity.x != 0:
			if is_on_floor():
				body.play("walk")
				if $FootstepTimer.is_stopped(): $FootstepTimer.start()
			body.flip_h = velocity.x > 0
		else:
			if is_on_floor(): body.play("idle")
	else:
		velocity = Vector2(0, 0)
	
	if Input.is_action_just_pressed("a") and perform_jump and not level_mgr.over:
		velocity.y = JUMP_VELOCITY
		perform_jump = false
		tween.tween_property($Body, "scale", Vector2(0.75, 1.5), 0.1)
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property($Body, "scale", Vector2(1, 1), 1.0)
		$"/root/JumpSfx".play()
		
	if is_on_floor():
		perform_jump = true
	else:
		velocity += get_gravity() * delta
		body.play("jump")
	
	move_and_slide()
	
	if position.y >= 203 and not level_mgr.over:
		level_mgr.over = true
		$"/root/DamageSfx".play()
		level_mgr.game_timeout()
	
	if level_mgr.over:
		collision.disabled = true
	
	ui_coin_signal.emit(coin)

func _on_footstep_timer_timeout() -> void:
	$"/root/FootstepSfx".play()
