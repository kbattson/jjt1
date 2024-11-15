extends CharacterBody2D

const SPEED : float = 20.0

@onready var direction_timer = $DirectionTimer

func _ready():
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
	body.queue_free()
	queue_free()
