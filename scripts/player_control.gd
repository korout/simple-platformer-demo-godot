extends CharacterBody2D

const SPEED: int = 110
const JUMP_VELOCITY: int = -280

var jump_active: bool

var health: int = 100
var coin: int

@onready var level_mgr: Node = $"../LevelManager"

@onready var body: AnimatedSprite2D = $Body
@onready var collision: CollisionShape2D = $Coll

signal ui_coin_signal

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	var tween = create_tween()
	
	if not level_mgr.over and not level_mgr.win:
		velocity.x = SPEED * Input.get_axis("left", "right")
		
		if velocity.x != 0:
			if is_on_floor():
				body.play("walk")
				if $FootstepTimer.is_stopped(): $FootstepTimer.start()
			body.flip_h = velocity.x > 0
		else: if is_on_floor(): body.play("idle")
	else: velocity.x = 0.0
	
	if Input.is_action_just_pressed("a") and jump_active and not level_mgr.over:
		velocity.y = JUMP_VELOCITY
		jump_active = false
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property($Body, "scale", Vector2(0.75, 1.5), 0.1)
		tween.tween_property($Body, "scale", Vector2(1, 1), 1.0)
		$"/root/JumpSfx".play()
		
	if is_on_floor():
		jump_active = true
	else:
		body.play("jump")
	
	move_and_slide()
	
	if position.y >= 203: kill()
	
	ui_coin_signal.emit(coin)
	
	if level_mgr.over: collision.disabled = true

func kill():
	if not level_mgr.over:
		level_mgr.over = true
		$"/root/DamageSfx".play()
		level_mgr.game_timeout()

func jumping_kill():
	if level_mgr.over:
		velocity.y = -350

func _on_footstep_timer_timeout() -> void:
	$"/root/FootstepSfx".play()
