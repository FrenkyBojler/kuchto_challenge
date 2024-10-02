extends RigidBody2D
class_name Projectile

@export var time_to_live := 1.0

signal on_projectile_hit(Node2D)

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	get_tree().create_timer(time_to_live).timeout.connect(func (): queue_free())
	
func _on_body_entered(body: Node2D) -> void:
	on_projectile_hit.emit(body)

func shoot() -> void:
	pass
