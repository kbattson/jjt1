extends CharacterBody2D

const SPEED : float = 20.0

@onready var anim = $Sprite2D

@onready var coin = load("res://Entities/Coin/coin.tscn")

var health : int = 2
var initial_velocity : Vector2 = Vector2(1,0.1)

func _ready():
	velocity = initial_velocity * SPEED

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
	anim.flip_h = velocity.x < 0


func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	health -= 1
	if health == 0:
		spawn_coins(1)
		queue_free()
		
func spawn_coins(amount: int):
	for i in range(amount):
		var instance = coin.instantiate()
		instance.spawn_pos = global_position
		get_tree().root.add_child.call_deferred(instance)
