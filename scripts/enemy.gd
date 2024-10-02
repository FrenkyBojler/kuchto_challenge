extends Node2D

class_name Enemy

@export var character: AttackingCharacterBody2D
var _player: AttackingCharacterBody2D

const SPEED = 100.0
const MIN_DISTANCE_TO_PLAYER = 5
var velocity := Vector2.ZERO

func _ready() -> void:
	character.got_hit.connect(_on_hit)

func _process(_delta: float) -> void:
	_move()
		
func _move() -> void:
	if _player != null:
		var distance_to_player = abs(character.global_position.distance_to(_player.global_position))
		if distance_to_player <= MIN_DISTANCE_TO_PLAYER:
			character.velocity = Vector2.ZERO
			return
		$NavigationAgent2D.target_position = _player.global_position
		character.velocity = (character.global_position.direction_to(_player.global_position)).normalized() * SPEED

func _set_player(player: AttackingCharacterBody2D) -> void:
	_player = player
	character.set_target(_player)

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is AttackingCharacterBody2D and (body as AttackingCharacterBody2D).is_player:
		_set_player(body)

func get_real_position() -> Vector2:
	return character.global_position
	
func _on_hit(damage: float) -> void:
	print_debug("Enemy just got hit by: " + str(damage))
