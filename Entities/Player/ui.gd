extends CanvasLayer

@onready var heart = load("res://UI/Heart/heart.tscn")
@onready var heart_container = $MarginContainer/VBoxContainer/HeartContainer
@onready var coin_label = $MarginContainer/VBoxContainer/CoinContainer/Count
	
func _on_player_update_health(new_health):
	while heart_container.get_child_count() > 0:
		var first_heart = heart_container.get_child(0)
		heart_container.remove_child(first_heart)
		first_heart.queue_free()
		
	while heart_container.get_child_count() < new_health:
		var instance = heart.instantiate()
		heart_container.add_child(instance)


func _on_player_update_coins(new_coins):
	coin_label.text = str(new_coins)
