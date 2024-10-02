extends Node2D

@export var character: AttackingCharacterBody2D

const SPEED = 100.0
var velocity := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direcrtion := Input.get_axis("ui_up", "ui_down")

	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if vertical_direcrtion:
		velocity.y = vertical_direcrtion * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	character.velocity = velocity
