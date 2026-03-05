extends Control

@onready var shader_component: ShaderComponent = $ShaderComponent

@export var function_type: functions
@export var white_strength: float = 0.25
@export var load_scene: PackedScene

enum functions{
	pause,
	unpause,
	load_scene,
}

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
		
		functions.pause:
			ui_manager._pause_game()
			
		functions.unpause:
			ui_manager._unpause()
			
		functions.load_scene:
			game_mngr._load_scene(load_scene)
			ui_manager._unpause()
			
