extends Node2D

func _ready():
	if Global.room_1_completed:
		$coin_nodes.queue_free()

func _on_coin_nodes_child_exiting_tree(_node):
	Global.room_1_completed = true
