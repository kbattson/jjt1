extends CharacterBody2D


const SPEED = 50.0

var init_direction: int

func _physics_process(delta):
	velocity.x = init_direction * SPEED * delta
	var collision = move_and_collide(velocity)
	
	if collision:
		queue_free()
	
