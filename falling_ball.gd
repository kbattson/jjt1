extends CharacterBody2D

const GRAV = 40.0

func _physics_process(delta):
	velocity.y = GRAV * delta

	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
