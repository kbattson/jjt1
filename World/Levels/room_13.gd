extends Node2D

var pos_1 = Vector2(248, 32)
var pos_2 = Vector2(403, 32)

var left_limit = 0
var right_limit = 576

var entered = false

func _on_player_area_body_entered(_body):
	if !entered:
		$player/player_camera.limit_left = 248
		$player/player_camera.limit_right = 408
		$boss/action_timer.start()
		SoundManager.click()
		$gate1.global_position = pos_1
		$gate2.global_position = pos_2	
		entered = true
	
	
func _on_boss_boss_killed():
	Global.player_curr_hp = Global.player_max_hp
	$gate1.global_position = Vector2(-100, -100)
	$gate2.global_position = Vector2(-100, -100)
	$player/player_camera.limit_left = left_limit
	$player/player_camera.limit_right = right_limit


func _on_spike_area_body_entered(_body):
	$player.global_position = Vector2(16, 40)
