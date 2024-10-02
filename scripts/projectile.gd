extends StaticBody2D
class_name Projectile

@export var time_to_live := 1.0

func _ready() -> void:
	get_tree().create_timer(time_to_live).timeout.connect(func (): queue_free())

func shoot(_target: Node2D) -> void:
	pass
