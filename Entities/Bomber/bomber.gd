extends CharacterBody2D

@onready var bomb = load("res://Entities/Bomber/bomb.tscn")
@onready var spawn_timer = $SpawnTimer

var health : int = 2

func _ready() -> void:
	rotation_degrees = -105
	
func _physics_process(_delta):
	velocity += get_gravity()
	move_and_slide()

func shoot():
	var instance = bomb.instantiate()
	instance.spawn_pos = global_position
	var x = cos(PI/180 * rotation_degrees)
	var y = sin(PI/180 * rotation_degrees)
	instance.initial_velocity = Vector2(x, y)
	get_tree().root.add_child.call_deferred(instance)

func _on_spawn_timer_timeout() -> void:
	shoot()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	health -= 1
	if health <= 0:
		queue_free()
