extends Node2D

@onready var shader: ShaderComponent = $ShaderComponent

var current_progress: float = 0.0

func _process(delta: float) -> void:
	
	current_progress = move_toward(current_progress, game_mngr.zombie_mngr.progress, delta * 0.05)
	shader._set_progress(current_progress)
