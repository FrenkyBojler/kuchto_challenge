extends Projectile

@export var speed := 500

func _physics_process(delta: float) -> void:
	if _target != null:
		look_at(_target.global_position)
		global_position += global_position.direction_to(_target.global_position) * speed * delta
