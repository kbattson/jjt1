extends Node

func laser_shoot():
	$shoot_sound.play()

func hit():
	$hit_sound.play()
	
func click():
	$click.play()
	
func explo_1():
	$AudioStreamPlayer2D.play()
	
func explo_2():
	$AudioStreamPlayer2D2.play()
	
func explo_3():
	$AudioStreamPlayer2D3.play()
	
func boss_death():
	$AudioStreamPlayer2D4.play()
	
func player_hurt():
	$AudioStreamPlayer2D5.play()
