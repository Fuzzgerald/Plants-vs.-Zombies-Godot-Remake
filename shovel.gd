extends Control

@onready var shader: ShaderComponent = $ShaderComponent

func _process(delta: float) -> void:
	if game_mngr.plant_mngr.click_type == game_mngr.plant_mngr.click_types.shovel:
		shader._set_white(0.25)
	else:
		shader._set_white(0)

func _gui_input(event: InputEvent) -> void:
	
	if(event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed
	):
		if game_mngr.plant_mngr.click_type == game_mngr.plant_mngr.click_types.shovel:
			game_mngr.plant_mngr._change_click(game_mngr.plant_mngr.click_types.none)
		else:
			game_mngr.plant_mngr._change_click(game_mngr.plant_mngr.click_types.shovel)
