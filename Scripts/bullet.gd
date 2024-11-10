extends CharacterBody2D

@onready var life_timer = $LifeTimer

const SPEED : float = 120.0
const OFFSET : int = 8

var flip : bool
var spawn_pos : Vector2

func _ready():
	spawn_pos.x += -OFFSET if flip else OFFSET
	global_position = spawn_pos
	
func _physics_process(delta):
	velocity.x = -SPEED if flip else SPEED
	move_and_collide(velocity * delta)

func _on_life_timer_timeout() -> void:
	queue_free()
