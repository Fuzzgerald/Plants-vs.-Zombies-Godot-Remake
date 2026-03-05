extends Node2D

@export var y_offset: int
@export var parent: Node2D

func _process(delta: float) -> void:
	parent.z_index = int(parent.global_position.y) + y_offset
