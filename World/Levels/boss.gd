extends StaticBody2D

@onready var anim = $anim
@onready var small = load("res://Global/boss_ball.tscn")
@onready var big = load("res://Global/big_ball.tscn")
@onready var falling = load("res://Global/falling_ball.tscn")

var left_pos = Vector2(233, -8)
var left_top = Vector2(275, 30)
var left_mid = Vector2(275, 40)
var left_bot = Vector2(275, 50)

var right_pos = Vector2(359, -8)
var right_top = Vector2(382, 30)
var right_mid = Vector2(382, 40)
var right_bot = Vector2(382, 50)

var falling_pos = Vector2(260, -30)

signal boss_anim_finished
signal boss_killed

var health: int = 60

func _ready():
	global_position = right_pos
	anim.flip_h = false
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("test1"):
		switch_pos()
	if Input.is_action_just_pressed("test2"):
		cast()
	if Input.is_action_just_pressed("test3"):
		shoot_small()
		
func switch_pos():
	anim.play("vanish")
	await boss_anim_finished
	if global_position == right_pos:
		global_position = left_pos
		anim.flip_h = true
	else:
		global_position = right_pos
		anim.flip_h = false
	anim.play_backwards("vanish")
	await boss_anim_finished
	anim.play("idle")
	
func shoot_small():
	anim.play("charging")
	await boss_anim_finished
	anim.play("idle")
	
	SoundManager.explo_3()
	
	var instance = small.instantiate()
	var instance2 = small.instantiate()
	var instance3 = small.instantiate()
	
	if global_position == right_pos:
		instance.global_position = right_bot
		instance.init_direction = -1
		get_tree().root.add_child(instance)
		
		await get_tree().create_timer(0.5).timeout
		
		instance2.global_position = right_top
		instance2.init_direction = -1
		get_tree().root.add_child(instance2)
		
		await get_tree().create_timer(0.5).timeout
		
		instance3.global_position = right_bot
		instance3.init_direction = -1
		get_tree().root.add_child(instance3)
	else:
		instance.global_position = left_bot
		instance.init_direction = 1
		get_tree().root.add_child(instance)
		
		await get_tree().create_timer(0.5).timeout
		
		instance2.global_position = left_top
		instance2.init_direction = 1
		get_tree().root.add_child(instance2)
		
		await get_tree().create_timer(0.5).timeout
		
		instance3.global_position = left_bot
		instance3.init_direction = 1
		get_tree().root.add_child(instance3)
	
func shoot_big():
	anim.play("charging")
	await boss_anim_finished
	anim.play("idle")
	
	SoundManager.explo_1()
	
	var instance = big.instantiate()
	if global_position == right_pos:
		instance.global_position = right_mid
		instance.init_direction = -1
	else:
		instance.global_position = left_mid
		instance.init_direction = 1
	get_tree().root.add_child(instance)
		
func cast():
	anim.play("cast")
	await boss_anim_finished
	anim.play("idle")
	
	SoundManager.explo_2()
	
	var cols = []
	while cols.size() < 11:
		var col = randi_range(0, 14)
		if col not in cols:
			cols.append(col)

	for col in cols:
		var instance = falling.instantiate()
		instance.global_position = falling_pos
		instance.global_position.x += 8 * col
		if global_position == left_pos:
			instance.global_position.x += 24
		get_tree().root.add_child(instance)
		

func _on_animated_sprite_2d_animation_finished():
	boss_anim_finished.emit()

func _on_hurtbox_body_entered(body):
	SoundManager.hit()
	body.free()
	health -= 1
	var tween: Tween = create_tween()
	tween.tween_property(anim, "modulate:v", 1, 0.1).from(15)
	if health <= 0:
		Engine.time_scale = 0
		await get_tree().create_timer(1, true, false, true).timeout
		Engine.time_scale = 1
		SoundManager.boss_death()
		switch_pos()
		await boss_anim_finished
		queue_free()
		boss_killed.emit()

func _on_action_timer_timeout():
	var action = randi_range(1, 3)
	if randi_range(1, 3) == 1:
		switch_pos()
		await boss_anim_finished
		await boss_anim_finished
	match action:
		1:
			shoot_small()
		2:
			shoot_big()
		3:
			cast()
