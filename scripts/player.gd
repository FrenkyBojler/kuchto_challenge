extends AttackableNode2D

class_name Player

const SPEED = 100.0

var velocity := Vector2.ZERO

@export var enemies_node: Node2D

func _ready() -> void:
	character.got_hit.connect(_on_hit)

func _physics_process(_delta: float) -> void:
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direcrtion := Input.get_axis("ui_up", "ui_down")

	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if vertical_direcrtion:
		velocity.y = vertical_direcrtion * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	character.velocity = velocity

func _on_hit(damage: float) -> void:
	print_debug("Player just got hit by: " + str(damage))


func _on_enemies_child_entered_tree(node: Node) -> void:
	if node is Enemy:
		_enemies.append(node)
		character.set_targets(_enemies)
