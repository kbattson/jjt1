extends Area2D

func _on_body_entered(_body):
	Global.respawn_scene_path = get_tree().current_scene.scene_file_path
	Global.respawn_pos = position
