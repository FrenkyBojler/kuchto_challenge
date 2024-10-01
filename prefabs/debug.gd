extends StaticBody2D

@export
var display_position_text := false

@onready
var position_text: RichTextLabel = $Control/RichTextLabel


func _process(delta: float) -> void:
	if display_position_text:
		position_text.text = str(global_position)
