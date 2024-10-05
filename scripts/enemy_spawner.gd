extends Node2D

@export var spawn_parent: Node2D
@export var enemies: Array[PackedScene]

func _ready() -> void:
	_spawn_random_enemy()

func _spawn_random_enemy() -> void:
	if enemies.size() <= 0:
		print_debug("No enemies assinged!")
		return
	var randomizer = RandomNumberGenerator.new()
	var random_index = randomizer.randi_range(0, enemies.size() - 1)
	var enemy = enemies[random_index]
	var instance = enemy.instantiate() as Enemy
	instance.global_position = global_position
	spawn_parent.add_child(instance)

func _on_spawn_enemy_timer_timeout() -> void:
	_spawn_random_enemy()
