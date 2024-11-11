extends StaticBody2D

var health : int = 3

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	if body.is_in_group("Projectile"):
		health -= 1
		if health == 0:
			queue_free()
		
