
extends Area2D

@export var next_level = ""
@export var spawn_pos: Vector2
@export var flattened: bool

func _ready():
	if flattened:
		$CollisionShape2D.rotate(PI/2)

func _on_body_entered(_body):
	call_deferred("change_scene")
	
func change_scene():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	Global.player_spawn_pos = spawn_pos
	if !next_level:
		return
	if !get_tree():
		return
	get_tree().change_scene_to_file.call_deferred(next_level)
