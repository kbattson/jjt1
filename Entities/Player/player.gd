extends CharacterBody2D

@onready var root_node = get_tree().root
@onready var projectile = load("res://Entities/Bullet/bullet.tscn")
@onready var anim = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var coyote_timer = $coyote_timer

const SPEED : float = 40.0
const JUMP_VELOCITY : float = -140.0
const FALL_GRAVITY_MULT : Vector2 = Vector2(1, 1.5)

signal update_health(new_health: int)
signal update_coins(new_coins: int)

var on_cooldown : bool = false
var plat_velocity = Vector2(0, 0)

var in_hit_flash: bool = false
var in_hit_cooldown: bool = false

var double_jump: bool = true

func _ready():
	global_position = Global.player_spawn_pos
	update_health.emit(Global.player_curr_hp)
	update_coins.emit(Global.player_coins)

func _physics_process(delta):
	if Input.is_action_just_pressed("test1"):
		respawn()
	if Input.is_action_just_pressed("test3"):
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		Global.player_spawn_pos = Vector2(387, -31)
		get_tree().change_scene_to_file.call_deferred('res://World/Levels/room_3.tscn')
		Global.double_jump_unlocked = true
		Global.player_max_hp += 1
		Global.player_curr_hp = Global.player_max_hp
		update_health.emit(Global.player_curr_hp)
	
	if Input.is_action_just_pressed("jump") and (!double_jump or is_on_floor() or !coyote_timer.is_stopped()):
		if !is_on_floor():
			double_jump = true
		velocity.y = JUMP_VELOCITY
		velocity.x = plat_velocity.x
		
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
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if in_hit_flash:
		anim.play("hit_flash")
	elif not is_on_floor():
		anim.play("jump")
	elif velocity.x == 0:
		anim.play("idle")
	elif velocity.x != 0:
		anim.play("run")

	if not is_on_floor():
		velocity += get_grav() * delta
	
	if is_on_floor() and Global.double_jump_unlocked:
		double_jump = false

	set_flip()
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()

	plat_velocity = get_platform_velocity()
	
func get_grav() -> Vector2:
	return get_gravity() if velocity.y < 0 else get_gravity() * FALL_GRAVITY_MULT
	

	
func set_flip() -> void:
	if velocity.x < 0:
		anim.flip_h = true 
	if velocity.x > 0:
		anim.flip_h = false
		
func shoot():
	SoundManager.laser_shoot()
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
		if body.is_in_group("spike"):
			global_position = Global.spike_respawn_pos
			take_damage()
		elif !in_hit_cooldown:
			hit_flash()
			take_damage()

	
	elif body.is_in_group("Coin"):
		body.queue_free()
		Global.player_coins += 1
		update_coins.emit(Global.player_coins)
		
func take_damage():
	hit_flicker()
	SoundManager.player_hurt()
	
	Global.player_curr_hp -= 1
	Global.player_curr_hp = max(Global.player_curr_hp, 0)
	update_health.emit(Global.player_curr_hp)
	
	if Global.player_curr_hp == 0:
		respawn()
	
func heal():
	Global.player_curr_hp += 1
	Global.player_curr_hp = min(Global.player_curr_hp, Global.player_max_hp)
	update_health.emit(Global.player_curr_hp)
	
func reset_health():
	Global.player_curr_hp = Global.player_max_hp
	update_health.emit(Global.player_curr_hp)
	
func _on_hit_cooldown_timeout():
	in_hit_cooldown = false
	
func hit_flicker():
	await get_tree().create_timer(0.4).timeout
	visible = false
	await get_tree().create_timer(0.15).timeout
	visible = true
	await get_tree().create_timer(0.4).timeout
	visible = false
	await get_tree().create_timer(0.15).timeout
	visible = true
	await get_tree().create_timer(0.4).timeout
	visible = false
	await get_tree().create_timer(0.15).timeout
	visible = true
	
func hit_flash():
	in_hit_cooldown = true
	$hit_cooldown.start()
	in_hit_flash = true
	Global.hit_stop_short()
	await get_tree().create_timer(0.3, true, false, true).timeout
	in_hit_flash = false
	
func respawn():
	visible = false
	reset_health()
	Global.player_spawn_pos = Global.respawn_pos
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file.call_deferred(Global.respawn_scene_path)
	await get_tree().create_timer(0.4).timeout
	visible = true
