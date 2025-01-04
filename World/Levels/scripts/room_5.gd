extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.room_5_completed:
		$coin_nodes.queue_free()


func _on_coin_nodes_child_exiting_tree(_node):
	Global.room_5_completed = true
