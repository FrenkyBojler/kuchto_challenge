extends AttackingCharacterBody2D

const SPEED = 100.0


func _physics_process(_delta: float) -> void:
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direcrtion := Input.get_axis("ui_up", "ui_down")
	
	if horizontal_direction < 0:
		_flip_character(true)
	elif horizontal_direction > 0:
		_flip_character(false)
		
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

func _on_default_weapon_on_attack() -> void:
	_attack()
