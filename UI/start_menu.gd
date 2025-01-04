extends CanvasLayer

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			SoundManager.click()
			$AnimatedSprite2D.play()
			$Label.hide()
	
func _on_animated_sprite_2d_animation_finished():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	Engine.time_scale = 0
	await get_tree().create_timer(3, true, false, true).timeout
	Engine.time_scale = 1
	Global.player_spawn_pos = Vector2(21, 20)
	get_tree().change_scene_to_file.call_deferred("res://World/Levels/room_0.tscn")
	
