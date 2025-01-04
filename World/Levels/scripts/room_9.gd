extends Node2D

@onready var jump_boots_area = $jump_boots_area
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.room_9_completed:
		$coin_nodes.queue_free()

func _on_coin_nodes_child_exiting_tree(_node):
	Global.room_9_completed = true
	

func _on_jump_boots_area_body_entered(_body):
	Engine.time_scale = 0
	await get_tree().create_timer(1, true, false, true).timeout
	Engine.time_scale = 1
	Global.double_jump_unlocked = true
	jump_boots_area.queue_free()
