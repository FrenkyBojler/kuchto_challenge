extends Node2D
class_name Weapon

@export var attack_range := 5

@export var damage: float = 10
@export var number_of_projectiles: int = 1
@export var attack_rate: float = 1

@export var projectile_prefab: PackedScene
@export var attach_projectiles_to_parent := false

var projectile_spawn_position: Vector2

var attack_timer: Timer
var attack_timer_tick := 0.1
var current_time_to_attack := 0.0

var _targets: Array[AttackableNode2D]
var _current_target: AttackingCharacterBody2D

signal on_attack

func _ready() -> void:
	_set_attack_timer()

func _attack() -> void:
	current_time_to_attack += attack_timer_tick
	if current_time_to_attack < (1 / attack_rate):
		return
	else:
		current_time_to_attack = 0.0
	
	if _targets.size() != 0:
		on_attack.emit()

func _set_attack_timer() -> void:
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = attack_timer_tick
	attack_timer.timeout.connect(_attack)
	attack_timer.one_shot = false
	attack_timer.start()
	
func set_targets(targets: Array[AttackableNode2D]) -> void:
	_targets = targets

func set_projectile_spawn_pos(pos: Vector2) -> void:
	projectile_spawn_position = pos
	
# TODO: Potentionaly very expensive
func _get_closes_enemy() -> AttackingCharacterBody2D:
	if _targets.size() == 0:
		return null
	var closest_enemy: AttackingCharacterBody2D = _targets[0].character
	var closest_distance: float = -1.0
	for target in _targets:
		var current_distance = abs(target.get_real_position().distance_to(get_parent().global_position))
		if closest_distance == -1.0 or current_distance < closest_distance:
			closest_enemy = target.character
			closest_distance = current_distance
	return closest_enemy

func _get_random_enemy_within_range() -> AttackingCharacterBody2D:
	if _targets.size() == 0:
		return null
	var randomizer = RandomNumberGenerator.new()
	var enemies_within_range = _targets.filter(func(enemy: AttackableNode2D): enemy.character.global_position.distance_to(get_parent().global_position) <= attack_range)
	if enemies_within_range.is_empty():
		return null
	return enemies_within_range.pick_random().character
	
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
		var closest_target = _get_closes_enemy()
		var random_target = _get_random_enemy_within_range()
		projectile.shoot(closest_target, random_target, damage)
