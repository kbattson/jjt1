extends StaticBody2D

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.frame = 0
	anim.play("default")

func _on_coin_area_body_entered(body):
	body.queue_free()
