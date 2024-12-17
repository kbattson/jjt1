extends CharacterBody2D

@onready var root_node = get_tree().root
@onready var projectile = load("res://Entities/Bullet/bullet.tscn")
@onready var anim = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer

const SPEED : float = 40.0
const JUMP_VELOCITY : float = -160.0
const FALL_GRAVITY_MULT : Vector2 = Vector2(1, 1.5)

var on_cooldown : bool = false

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
		
	if Input.is_action_pressed("down") and is_on_floor():
		position.y += 1
		
	if Input.is_action_pressed("shoot"):
		if !on_cooldown:
			shoot()

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_on_floor():
		anim.play("jump")
	elif velocity.x == 0:
		anim.play("idle")
	elif velocity.x != 0:
		anim.play("run")

	if not is_on_floor():
		velocity += get_grav() * delta

	set_flip()
	move_and_slide()
	
func get_grav() -> Vector2:
	return get_gravity() if velocity.y < 0 else get_gravity() * FALL_GRAVITY_MULT
	
func set_flip() -> void:
	if velocity.x < 0:
		anim.flip_h = true 
	if velocity.x > 0:
		anim.flip_h = false
		
func shoot():
	var instance = projectile.instantiate()
	instance.flip = anim.flip_h
	instance.spawn_pos = global_position
	root_node.add_child.call_deferred(instance)
	on_cooldown = true
	shoot_timer.start()

func _on_shoot_cooldown_timeout():
	on_cooldown = false
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		global_position = Vector2(10, 10)
	
	
	
	
	
