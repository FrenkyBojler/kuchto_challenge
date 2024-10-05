extends Projectile

@export var speed := 500

func _physics_process(delta: float) -> void:
	if _random_target != null:
		look_at(_random_target.global_position)
		global_position += global_position.direction_to(_random_target.global_position) * speed * delta
