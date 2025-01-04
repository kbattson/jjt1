extends Node2D

@onready var walker = load("res://Entities/Walker/walker.tscn")
@onready var wanderer = load("res://Entities/Wanderer/wanderer.tscn")
@onready var coin_node = load("res://Entities/CoinNode/coin_node.tscn")

var wave: int = 0

func _ready():
	$locked_wall.position = Vector2(-100, 20)

func _on_locked_area_body_entered(_body):
	if !Global.room_8_completed:
		$locked_wall.position = Vector2(37, 20)
		wave = 1
		spawn_wave_1()
	
func spawn_wave_1():
	await get_tree().create_timer(1).timeout
	var in_1 = walker.instantiate()
	in_1.spawn_pos_enabled = true
	in_1.spawn_pos = Vector2(64, -12)
	
	var in_2 = walker.instantiate()
	in_2.spawn_pos_enabled = true
	in_2.spawn_pos = Vector2(144, -12)
	
	var in_3 = wanderer.instantiate()
	in_3.spawn_pos_enabled = true
	in_3.spawn_pos = Vector2(104, 32)
	
	$enemies.add_child.call_deferred(in_1)
	$enemies.add_child.call_deferred(in_2)
	$enemies.add_child.call_deferred(in_3)
	
func spawn_wave_2():
	await get_tree().create_timer(1).timeout
	var in_1 = walker.instantiate()
	in_1.spawn_pos_enabled = true
	in_1.spawn_pos = Vector2(64, 44)
	var in_2 = walker.instantiate()
	in_2.spawn_pos_enabled = true
	in_2.spawn_pos = Vector2(144, 44)
	var in_3 = wanderer.instantiate()
	in_3.spawn_pos_enabled = true
	in_3.spawn_pos = Vector2(152, 44)
	var in_4 = wanderer.instantiate()
	in_4.spawn_pos_enabled = true
	in_4.spawn_pos = Vector2(152, -16)
	var in_5 = wanderer.instantiate()
	in_5.spawn_pos_enabled = true
	in_5.spawn_pos = Vector2(56, 44)
	var in_6 = wanderer.instantiate()
	in_6.spawn_pos_enabled = true
	in_6.spawn_pos = Vector2(56, -16)
	
	$enemies.add_child.call_deferred(in_1)
	$enemies.add_child.call_deferred(in_2)
	$enemies.add_child.call_deferred(in_3)
	$enemies.add_child.call_deferred(in_4)
	$enemies.add_child.call_deferred(in_5)
	$enemies.add_child.call_deferred(in_6)
	
	
func spawn_wave_3():
	await get_tree().create_timer(1).timeout
	var in_3 = wanderer.instantiate()
	in_3.spawn_pos_enabled = true
	in_3.spawn_pos = Vector2(152, 44)
	var in_4 = wanderer.instantiate()
	in_4.spawn_pos_enabled = true
	in_4.spawn_pos = Vector2(152, -16)
	var in_5 = wanderer.instantiate()
	in_5.spawn_pos_enabled = true
	in_5.spawn_pos = Vector2(56, 44)
	var in_6 = wanderer.instantiate()
	in_6.spawn_pos_enabled = true
	in_6.spawn_pos = Vector2(56, -16)
	
	var in_7 = wanderer.instantiate()
	in_7.spawn_pos_enabled = true
	in_7.spawn_pos = Vector2(100, 44)
	var in_8 = wanderer.instantiate()
	in_8.spawn_pos_enabled = true
	in_8.spawn_pos = Vector2(100, -16)

	$enemies.add_child.call_deferred(in_3)
	$enemies.add_child.call_deferred(in_4)
	$enemies.add_child.call_deferred(in_5)
	$enemies.add_child.call_deferred(in_6)
	$enemies.add_child.call_deferred(in_7)
	$enemies.add_child.call_deferred(in_8)
	
	
func _on_enemies_child_exiting_tree(_node):
	if $enemies.get_child_count() == 1:
		wave += 1
		if wave == 2:
			spawn_wave_2()
		elif wave == 3:
			spawn_wave_3()
		elif wave == 4:
			$locked_wall.position = Vector2(-100, 20)
			var coin_node_1 = coin_node.instantiate()
			coin_node_1.spawn_pos_enabled = true
			coin_node_1.spawn_pos = Vector2(92, 44)
			coin_node_1.health = 3
			var coin_node_2 = coin_node.instantiate()
			coin_node_2.spawn_pos_enabled = true
			coin_node_2.spawn_pos = Vector2(100, 44)
			coin_node_2.health = 3
			var coin_node_3 = coin_node.instantiate()
			coin_node_3.spawn_pos_enabled = true
			coin_node_3.spawn_pos = Vector2(108, 44)
			coin_node_3.health = 3
			get_tree().root.add_child.call_deferred(coin_node_1)
			get_tree().root.add_child.call_deferred(coin_node_2)
			get_tree().root.add_child.call_deferred(coin_node_3)
			$heart_area.position = Vector2(104, 6)
			Global.room_8_completed = true
		


func _on_heart_area_body_entered(_body):
	Global.player_max_hp += 1
	$player.reset_health()
	$heart_area.queue_free()
