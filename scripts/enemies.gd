extends Node2D

func get_closest_enemy_to_position(position: Vector2) -> AttackableNode2D:
	return null

func get_random_enemy_within_range_from_origin(range: float, origin: Vector2) -> AttackableNode2D:
	return null

func has_children() -> bool:
	return get_child_count() != 0
