extends Node2D

@onready var heart_1 = $Area2D
@onready var heart_2 = $Area2D

@onready var player = $player

func _ready():
	if Global.heart_1_bought:
		heart_1.queue_free()
	if Global.heart_2_bought:
		heart_2.queue_free()

func _on_area_2d_body_entered(_body):
	if Global.player_coins >= 60:
		Global.heart_1_bought = true
		heart_1.queue_free()
		Global.player_coins -= 60
		player.update_coins.emit(Global.player_coins)
		Global.player_max_hp += 1
		Global.player_curr_hp = Global.player_max_hp
		player.update_health.emit(Global.player_curr_hp)
		
func _on_area_2d_2_body_entered(_body):
	if Global.player_coins >= 90:
		Global.heart_2_bought = true
		heart_1.queue_free()
		Global.player_coins -= 90
		player.update_coins.emit(Global.player_coins)
		Global.player_max_hp += 1
		Global.player_curr_hp = Global.player_max_hp
		player.update_health.emit(Global.player_curr_hp)
