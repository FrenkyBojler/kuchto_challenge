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

var _targets: Array[AttackingCharacterBody2D] = []
var _current_target: AttackingCharacterBody2D

signal on_attack

var is_player_weapon := true

func _ready() -> void:
	_set_enemies_collider()
	_set_attack_timer()

func _set_enemies_collider() -> void:
	if not is_player_weapon:
		return

	var enemies_area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = attack_range
	collision.shape = shape
	enemies_area.add_child(collision)

	enemies_area.body_entered.connect(_on_enemy_entered)

	add_child(enemies_area)

func _on_enemy_entered(body: Node2D) -> void:
	if body is AttackingCharacterBody2D and !(body as AttackingCharacterBody2D).is_player:
		body.tree_exited.connect(_on_enemy_removed_from_game.bind(body))
		_targets.append(body)

func _on_enemy_exited(body: Node2D) -> void:
	if body is AttackingCharacterBody2D and is_player_weapon == (body as AttackingCharacterBody2D).is_player:
		body.tree_exited.disconnect(_on_enemy_removed_from_game.bind(body))
		_targets.erase(body)

func _on_enemy_removed_from_game(body: Node2D) -> void:
	_targets.erase(body)

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

func set_targets(targets: Array[AttackingCharacterBody2D], is_player_weapon: bool) -> void:
	_targets = targets
	self.is_player_weapon = is_player_weapon

func set_projectile_spawn_pos(pos: Vector2) -> void:
	projectile_spawn_position = pos

# TODO: Potentionaly very expensive
func _get_closes_enemy() -> AttackingCharacterBody2D:
	if _targets.size() == 0:
		return null
	elif _targets.size() == 1:
		return _targets[0]

	var closest_enemy: AttackingCharacterBody2D = _targets[0]
	var closest_distance: float = -1.0
	for target in _targets:
		var current_distance = abs(target.global_position.distance_to(get_parent().global_position))
		if closest_distance == -1.0 or current_distance < closest_distance:
			closest_enemy = target
			closest_distance = current_distance
	return closest_enemy

func _get_random_enemy_within_range() -> AttackingCharacterBody2D:
	if _targets.size() == 0:
		return null
	elif _targets.size() == 1:
		return _targets[0]

	return _targets.pick_random()

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
		var _closest_target = _get_closes_enemy()
		var _random_target = _get_random_enemy_within_range()
		
		projectile.shoot(_closest_target, _random_target, damage)
