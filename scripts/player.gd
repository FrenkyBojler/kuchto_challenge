extends Node2D

class_name Player

@export var character: AttackingCharacterBody2D
@export var enemies: Node2D

const SPEED = 100.0

var velocity := Vector2.ZERO

func _ready() -> void:
	character.got_hit.connect(_on_hit)

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
	character.set_target(_get_closes_enemy())

func _get_closes_enemy() -> AttackingCharacterBody2D:
	var closest_enemy: AttackingCharacterBody2D = (enemies.get_child(0) as Enemy).character
	var closest_distance: float = -1.0
	for enemy in enemies.get_children():
		if enemy is Enemy:
			var current_distance = abs(enemy.get_real_position().distance_to(character.global_position))
			if closest_distance == -1.0 or current_distance < closest_distance:
				closest_enemy = enemy.character
				closest_distance = current_distance
		else:
			continue
	return closest_enemy


func _on_hit(damage: float) -> void:
	print_debug("Player just got hit by: " + str(damage))
