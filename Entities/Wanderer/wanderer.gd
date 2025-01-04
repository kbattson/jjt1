extends CharacterBody2D

const SPEED : float = 20.0

@onready var direction_timer = $DirectionTimer

@onready var coin = load("res://Entities/Coin/coin.tscn")

var spawn_pos_enabled: bool = false
var spawn_pos: Vector2

func _ready():
	if spawn_pos_enabled:
		global_position = spawn_pos
	_on_direction_timer_timeout()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
func _on_direction_timer_timeout() -> void:
	var angle = randf_range(0, 2 * PI)
	velocity = Vector2(cos(angle), sin(angle)) * SPEED
	direction_timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	SoundManager.hit()
	body.queue_free()
	var tween: Tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:v", 1, 0.1).from(15)
	await get_tree().create_timer(0.05).timeout
	queue_free()
	Global.spawn_coins(global_position, 1)
	
