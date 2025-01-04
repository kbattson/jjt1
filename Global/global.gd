extends Node

@onready var coin = load("res://Entities/Coin/coin.tscn")

var player_max_hp: int = 3
var player_curr_hp: int = player_max_hp
var player_coins : int = 0

var in_shop = false

var heart_1_bought = false
var heart_2_bought = false

var player_spawn_pos: Vector2 = Vector2(-8, -8)

var respawn_scene_path = "res://World/Levels/room_4.tscn"
var respawn_pos: Vector2 = Vector2(5, 30)

var spike_respawn_pos: Vector2

var double_jump_unlocked: bool = false

var room_1_completed: bool = false
var room_3_completed: bool = false
var room_5_completed: bool = false
var room_6_completed: bool = false
var room_7_completed: bool = false
var room_9_completed: bool = false
var room_8_completed: bool = false

var has_key: bool = false

func spawn_coins(pos: Vector2, amount: int):
	for i in range(amount):
		var instance = coin.instantiate()
		instance.spawn_pos = pos
		get_tree().root.add_child.call_deferred(instance)

func hit_stop_short():
	Engine.time_scale = 0
	await get_tree().create_timer(0.3, true, false, true).timeout
	Engine.time_scale = 1
