extends CharacterBody2D

@onready var coin = load("res://Entities/Coin/coin.tscn")
@onready var bullet = load("res://Entities/Shooter/shooter_bullet.tscn")
@onready var sprite = $Sprite2D
@onready var bullet_spawn = $BulletSpawn

var health: int = 2
@export var flip: bool

func _ready():
	sprite.flip_h = flip
	if flip:
		bullet_spawn.position.x *= -1
	
func _physics_process(_delta):
	velocity += get_gravity()
	move_and_slide()
	
func shoot():
	var instance = bullet.instantiate()
	instance.spawn_pos = bullet_spawn.global_position
	if flip:
		instance.linear_velocity = Vector2(1, 0)
	else:
		instance.linear_velocity = Vector2(-1, 0)
	get_parent().add_child.call_deferred(instance)

	
func _on_hurtbox_body_entered(body):
	SoundManager.hit()
	if body.is_in_group("Projectile"):
		body.queue_free()
		var tween: Tween = create_tween()
		tween.tween_property($Sprite2D, "modulate:v", 1, 0.1).from(15)
		health -= 1
		if health == 0:
			await get_tree().create_timer(0.05).timeout
			Global.spawn_coins(global_position, int(randf() * 2) + 1)
			queue_free()
			
			
func _on_spawn_timer_timeout():
	shoot()
