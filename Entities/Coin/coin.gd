extends RigidBody2D

var spawn_pos

const SPEED: float = 30.0

func _ready():
	global_position = spawn_pos
	var angle = randf() * PI * 2
	if angle < PI:
		angle += PI
	apply_central_impulse(Vector2(cos(angle) * SPEED, sin(angle) * SPEED))
