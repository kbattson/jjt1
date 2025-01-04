extends RigidBody2D

@export var health : int

var spawn_pos_enabled: bool = false
var spawn_pos: Vector2

func _ready():
	if spawn_pos_enabled:
		global_position = spawn_pos

func _on_hurtbox_body_entered(body):
	SoundManager.hit()
	body.queue_free()
	var tween: Tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:v", 1, 0.1).from(15)
	health -= 1
	Global.spawn_coins(global_position, int(randf() * 2) + 1)
	if health <= 0:
		await get_tree().create_timer(0.05).timeout
		queue_free()
