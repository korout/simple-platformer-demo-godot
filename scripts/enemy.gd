extends CharacterBody2D

const SPEED: int = 30
const JUMP_VELOCITY: int = -280

@onready var body: AnimatedSprite2D = $Body
@onready var collision: CollisionShape2D = $Coll

@export var reverse: bool
@export var turn_time: float = 1.0

func _ready() -> void:
	$Timer.start(turn_time)

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	$Body.flip_h = not reverse
	if reverse:
		velocity.x = -SPEED
	else:
		velocity.x = SPEED
	body.play("walk")
	move_and_slide()

func _on_timer_timeout() -> void:
	reverse = not reverse

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.kill()
		body.jumping_kill()

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$"/root/DamageSfx".play()
		queue_free()
