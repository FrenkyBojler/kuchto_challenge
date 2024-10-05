extends Area2D
class_name Projectile

@export var time_to_live := 1.0
var _damage: float
var _closest_target: AttackingCharacterBody2D
var _random_target: AttackingCharacterBody2D

func _ready() -> void:
	get_tree().create_timer(time_to_live).timeout.connect(func (): queue_free())
	connect("area_entered", on_area_entered)

func shoot(closest_target: AttackingCharacterBody2D, random_target: AttackingCharacterBody2D, damage: float) -> void:
	_damage = damage
	_closest_target = closest_target
	_random_target = random_target
	_child_shoot(_closest_target, random_target, damage)
	
func _child_shoot(_closest_target: AttackingCharacterBody2D, _random_target: AttackingCharacterBody2D, _damage: float) -> void:
	pass

func on_area_entered(area: Area2D) -> void:
	var area_node = area.get_parent()
	if area_node is AttackingCharacterBody2D and area_node == _closest_target or area_node == _random_target:
		area_node.got_hit.emit(_damage)
		queue_free()
