extends Control

enum Functions {
	pause,
	unpause,
	load_scene,
}

@export var function_type: Functions
@export var white_strength: float = 0.25
@export var load_scene: PackedScene

@onready var shader_component: ShaderComponent = $ShaderComponent

func _gui_input(event: InputEvent) -> void:
	
	if(event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed
	):
		_get_function()
		
func _mouse_entered() -> void:
	shader_component._set_white(white_strength)
	
func _mouse_exited() -> void:
	shader_component._set_white(0)
	
func _get_function():
	
	match function_type:
		
		Functions.pause:
			ui_manager._pause_game()
			
		Functions.unpause:
			ui_manager._unpause()
			
		Functions.load_scene:
			game_mngr._load_scene(load_scene)
			ui_manager._unpause()
			
