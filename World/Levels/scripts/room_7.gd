extends Node2D

func _ready():
	if Global.room_7_completed:
		$coin_nodes.queue_free()
	if Global.has_key:
		$key_gate.queue_free()

func _on_key_body_entered(_body):
	Global.has_key = true
	$key.queue_free()

func _on_area_2d_body_entered(_body):
	if Global.has_key:
		$key_gate.queue_free()


func _on_coin_nodes_child_exiting_tree(_node):
	Global.room_7_completed = true
