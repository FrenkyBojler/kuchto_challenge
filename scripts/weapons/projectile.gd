extends Area2D
class_name Projectile

@export var time_to_live := 1.0
var _damage: float
var _target: AttackingCharacterBody2D

func _ready() -> void:
	get_tree().create_timer(time_to_live).timeout.connect(func (): queue_free())
	connect("area_entered", on_area_entered)

func shoot(target: AttackingCharacterBody2D, damage: float) -> void:
	_damage = damage
	_target = target
	_child_shoot(target, damage)
	
func _child_shoot(_target: AttackingCharacterBody2D, _damage) -> void:
	pass

func on_area_entered(area: Area2D) -> void:
	var area_node = area.get_parent()
	if area_node is AttackingCharacterBody2D and area_node == _target:
		area_node.got_hit.emit(_damage)
		queue_free()
