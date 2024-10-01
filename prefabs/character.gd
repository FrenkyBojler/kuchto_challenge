extends CharacterBody2D

const SPEED = 100.0

@onready var animation_player = $AnimationPlayer

var is_attacking := false

func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direcrtion := Input.get_axis("ui_up", "ui_down")
	
	if horizontal_direction < 0:
		$Sprite2D.flip_h = true
	elif horizontal_direction > 0:
		$Sprite2D.flip_h = false
	
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if vertical_direcrtion:
		velocity.y = vertical_direcrtion * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	_handle_animations()
	_attack()

func _attack() -> void:
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		animation_player.play("attack", -1, 2)

func _handle_animations() -> void:
	if is_attacking:
		return

	if velocity.y != 0 or velocity.x != 0:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func _on_attack_animation_finish() -> void:
	is_attacking = false
