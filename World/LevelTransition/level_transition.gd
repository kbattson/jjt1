
extends Area2D

@export var next_level = ""

func _on_body_entered(_body):
	call_deferred("change_scene")
	
func change_scene():
	get_tree().change_scene_to_file(next_level)
