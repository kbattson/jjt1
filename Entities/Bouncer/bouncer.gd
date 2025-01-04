extends CharacterBody2D

const SPEED : float = 20.0

@onready var anim = $Sprite2D

@onready var coin = load("res://Entities/Coin/coin.tscn")

var health : int = 2
var initial_velocity : Vector2 = Vector2(1,0.1)

func _ready():
	if randf() < 0.5:
		initial_velocity.y *= -1
	velocity = initial_velocity * SPEED

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
	anim.flip_h = velocity.x < 0


func _on_hurtbox_body_entered(body: Node2D) -> void:
	SoundManager.hit()
	body.queue_free()
	var tween: Tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:v", 1, 0.1).from(15)
	health -= 1
	if health == 0:
		await get_tree().create_timer(0.05).timeout
		Global.spawn_coins(global_position, randi_range(0, 1))
		queue_free()
