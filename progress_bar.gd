extends Node2D

var current_progress: float = 0.0

@onready var shader: ShaderComponent = $ShaderComponent

func _process(delta: float) -> void:
	
	current_progress = move_toward(current_progress, game_mngr.zombie_mngr.progress, delta * 0.05)
	shader._set_progress(current_progress)
