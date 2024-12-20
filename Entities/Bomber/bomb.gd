extends RigidBody2D

const SPEED : float = 150.0

@onready var explode_timer = $ExplosionTimer
@onready var duration_timer = $ExplodeDurationTimer
@onready var anim = $AnimatedSprite2D
@onready var collider = $CollisionShape2D

var spawn_pos : Vector2
var initial_velocity : Vector2

func _ready():
	global_position = spawn_pos
	linear_velocity = initial_velocity * SPEED

func _on_explosion_timer_timeout() -> void:
	anim.play("explode")
	freeze = true
	collider.scale = Vector2(3, 3)
	duration_timer.start()

func _on_explode_duration_timer_timeout() -> void:
	queue_free()
