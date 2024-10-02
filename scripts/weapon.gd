extends Node2D
class_name Weapon

@export var damage: float = 10
@export var number_of_projectiles: int = 1
@export var attack_rate: float = 1

@export var projectile_spawn_position: Node2D
@export var projectile_prefab: PackedScene

var attack_timer: Timer
var attack_timer_tick := 0.1
var current_time_to_attack := 0.0

signal on_attack

func _ready() -> void:
	_set_attack_timer()

func _attack() -> void:
	current_time_to_attack += attack_timer_tick
	if current_time_to_attack < (1 / attack_rate):
		return
	else:
		current_time_to_attack = 0.0

	on_attack.emit()

func _set_attack_timer() -> void:
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = attack_timer_tick
	attack_timer.timeout.connect(_attack)
	attack_timer.one_shot = false
	attack_timer.start()

func _on_character_actual_attack_trigger() -> void:
	for i in number_of_projectiles:
		var projectile = projectile_prefab.instantiate() as Projectile
		get_tree().root.add_child(projectile)
		projectile.global_position = projectile_spawn_position.global_position
		projectile.shoot()
