extends AnimatableBody2D

@export var speed: float = 0.0  # Movement speed
@export var waypoints: Array[Vector2] = [Vector2(0, 0), Vector2(0, 0)]  # Movement points
@export var loop: bool = true  # Should the platform loop?

@export var num_of_tiles: int

var current_index: int = 0  # Current target waypoint
var moving_forward: bool = true


func _ready():
	if num_of_tiles <= 2:
		$Sprite2D3.visible = false
		$CollisionShape2D3.disabled = true
	if num_of_tiles == 1:
		$Sprite2D2.visible = false
		$CollisionShape2D2.disabled = true

func _physics_process(delta: float):
	if waypoints.size() < 2:
		return  # No movement if there are fewer than 2 waypoints

	var target = waypoints[current_index]
	var direction = (target - position).normalized()

	# Move toward the target waypoint
	var move_amount = speed * delta
	if (target - position).length() > move_amount:
		position += direction * move_amount
	else:
		position = target  # Snap to target
		_update_next_waypoint()

func _update_next_waypoint():
	if loop:
		current_index = (current_index + 1) % waypoints.size()
	else:
		if moving_forward:
			current_index += 1
			if current_index >= waypoints.size():
				moving_forward = false
				current_index -= 2  # Move to the previous point
		else:
			current_index -= 1
			if current_index < 0:
				moving_forward = true
				current_index += 2
