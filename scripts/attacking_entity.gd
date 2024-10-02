extends CharacterBody2D
class_name AttackingCharacterBody2D

signal actual_attack_trigger

@export var weapon: Weapon

@export var top_left_spawn_position: Node2D
@export var top_right_spawn_position: Node2D
@export var top_spawn_position: Node2D
@export var bottom_left_spawn_position: Node2D
@export var bottom_right_spawn_position: Node2D
@export var bottom_spawn_position: Node2D
@export var left_spawn_position: Node2D
@export var right_spawn_position: Node2D

@onready var animation_player = $AnimationPlayer
var is_attacking := false

func _ready() -> void:
	if weapon != null:
		actual_attack_trigger.connect(weapon.actual_attack_trigger)
		weapon.on_attack.connect(_attack)
		
func _physics_process(delta: float) -> void:
	_child_physics_process(delta)
	_swap_projectile_spawn_pos()
	_move()
	
func _child_physics_process(_delta: float) -> void:
	pass
	
func _move() -> void:
	move_and_slide()
	_handle_animations()
	
	if velocity.x < 0:
		_flip_character(true)
	elif velocity.x > 0:
		_flip_character(false)

func _on_attack_animation_finish() -> void:
	actual_attack_trigger.emit()
	is_attacking = false

func _swap_projectile_spawn_pos() -> void:
	if weapon.projectile_spawn_position == Vector2.ZERO:
		weapon.set_projectile_spawn_pos(right_spawn_position.global_position)
	if velocity.x < 0 and velocity.y < 0:
		# TOP LEFT
		weapon.set_projectile_spawn_pos(top_left_spawn_position.global_position)
	elif velocity.x > 0 and velocity.y < 0:
		# TOP RIGHT
		weapon.set_projectile_spawn_pos(top_right_spawn_position.global_position)
	elif velocity.x == 0 and velocity.y < 0:
		# TOP
		weapon.set_projectile_spawn_pos(top_spawn_position.global_position)
	elif velocity.x < 0 and velocity.y > 0:
		# BOTTOM LEFT
		weapon.set_projectile_spawn_pos(bottom_left_spawn_position.global_position)
	elif velocity.x > 0 and velocity.y > 0:
		# BOTTOM RIGHT
		weapon.set_projectile_spawn_pos(bottom_right_spawn_position.global_position)
	elif velocity.x == 0 and velocity.y > 0:
		# BOTTOM
		weapon.set_projectile_spawn_pos(bottom_spawn_position.global_position)
	elif velocity.x < 0 and velocity.y == 0:
		# LEFT
		weapon.set_projectile_spawn_pos(left_spawn_position.global_position)
	elif velocity.x > 0 and velocity.y == 0:
		# RIGHT
		weapon.set_projectile_spawn_pos(right_spawn_position.global_position)


func _attack() -> void:
	is_attacking = true
	animation_player.play("attack", -1, 2)

func _handle_animations() -> void:
	if is_attacking:
		return

	if velocity.y != 0 or velocity.x != 0:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func _flip_character(left: bool) -> void:
	if left:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
