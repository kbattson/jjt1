extends CharacterBody2D

const SPEED : float = 1200.0
const OFFSET : int = 10

var health : int = 2
var flipped : bool = false

@onready var ahead_cast = $AheadCast
@onready var down_cast = $DownCast
@onready var anim = $AnimatedSprite2D

@onready var coin = load("res://Entities/Coin/coin.tscn")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectile"):
		body.queue_free()
		health -= 1
		if health == 0:
			spawn_coins(int(randf() * 2) + 1)
			queue_free()
			
func _physics_process(delta):
	velocity.x = -SPEED * delta if flipped else SPEED * delta
	
	if !down_cast.is_colliding() or ahead_cast.is_colliding():
		flipped = false if flipped else true
		flip()
	
	move_and_slide()

func flip():
	if flipped:
		anim.flip_h = true
		down_cast.position.x -= OFFSET
		ahead_cast.scale.x *= -1
	else:
		anim.flip_h = false
		down_cast.position.x += OFFSET
		ahead_cast.scale.x *= -1
		
func spawn_coins(amount: int):
	for i in range(amount):
		var instance = coin.instantiate()
		instance.spawn_pos = global_position
		get_tree().root.add_child.call_deferred(instance)
