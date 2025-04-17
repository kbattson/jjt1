extends CharacterBody2D

const SPEED : float = 2400.0
const OFFSET : int = 10

var health : int = 2
var flipped : bool = false

@onready var ahead_cast = $AheadCast
@onready var down_cast = $DownCast
@onready var anim = $AnimatedSprite2D
@onready var coin = load("res://Entities/Coin/coin.tscn")

var spawn_pos_enabled: bool = false
var spawn_pos: Vector2

func _ready():
	if spawn_pos_enabled:
		global_position = spawn_pos

func _on_hurtbox_body_entered(body: Node2D) -> void:
	SoundManager.hit()
	if body.is_in_group("Projectile"):
		body.queue_free()
		health -= 1
		var tween: Tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.1).from(15)
		if health == 0:
			await get_tree().create_timer(0.05).timeout
			Global.spawn_coins(global_position, randi_range(1, 2))
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
