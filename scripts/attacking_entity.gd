extends CharacterBody2D
class_name AttackingCharacterBody2D

signal actual_attack_trigger

@onready var animation_player = $AnimationPlayer
var is_attacking := false

func _physics_process(_delta: float) -> void:
	_attack()

func _attack() -> void:
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		animation_player.play("attack", -1, 2)

func _on_attack_animation_finish() -> void:
	actual_attack_trigger.emit()
	is_attacking = false
