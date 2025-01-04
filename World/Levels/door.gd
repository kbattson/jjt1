extends Area2D

@onready var interact_text = $Label

var colliding = false
var in_shop = false

func _ready():
	interact_text.hide()

func _on_body_entered(_body):
	colliding = true
	interact_text.show()
	
func _on_body_exited(_body):
	colliding = false
	interact_text.hide()
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("interact"):
		if colliding:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			if Global.in_shop:
				Global.in_shop = false
				Global.player_spawn_pos = Vector2(192, -38)
				get_tree().change_scene_to_file.call_deferred('res://World/Levels/room_2.tscn')
			else:
				Global.in_shop = true
				Global.player_spawn_pos = Vector2(5, -5)
				get_tree().change_scene_to_file.call_deferred("res://World/Levels/shop.tscn")
