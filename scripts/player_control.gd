extends CharacterBody2D

const SPEED = 110.0
const JUMP_VELOCITY = -280.0

var perform_jump : bool

var health = 100
var coin: int
@export var coin_label: Label

@export var level_mgr: Node

func _physics_process(delta):
	var tween = create_tween()
	
	if not level_mgr.over and not level_mgr.win:
		velocity.x = move_toward(velocity.x, SPEED * Input.get_axis("left", "right"), 20)
		if velocity.x != 0:
			if is_on_floor(): $Body.play("walk")
			$Body.flip_h = velocity.x > 0
		else:
			if is_on_floor(): $Body.play("idle")
	else:
		velocity = Vector2(0, 0)
	
	if Input.is_action_just_pressed("jump") and perform_jump and not level_mgr.over:
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
		$Body.play("jump")
	
	move_and_slide()
	
	if position.y >= 192 and not level_mgr.over:
		level_mgr.over = true
		$"/root/DamageSfx".play()
		level_mgr.game_timeout()
	
	if level_mgr.over:
		$Coll.disabled = true
	
	coin_label.text = str(coin)
