extends Node2D
class_name Weapon

@export var damage: float = 10
@export var number_of_projectiles: int = 1
@export var attack_rate: float = 1

@export var projectile_prefab: PackedScene

@export var attach_projectiles_to_parent := false

var projectile_spawn_position: Vector2

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

func set_projectile_spawn_pos(pos: Vector2) -> void:
	projectile_spawn_position = pos

# Connected from attacking_entity.gd
func actual_attack_trigger() -> void:
	if projectile_spawn_position == Vector2.ZERO:
		print_debug("No projectile spawn position assigned!")
		return

	for i in number_of_projectiles:
		var projectile = projectile_prefab.instantiate() as Projectile
		if attach_projectiles_to_parent:
			add_child(projectile)
		else:
			get_tree().root.add_child(projectile)
		projectile.global_position = projectile_spawn_position
		#projectile.shoot()
