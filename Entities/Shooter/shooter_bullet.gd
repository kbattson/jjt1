extends RigidBody2D

const SPEED: float = 50.0

var spawn_pos: Vector2

func _ready():
	global_position = spawn_pos
	linear_velocity *= SPEED

func _physics_process(_delta):
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		queue_free()
