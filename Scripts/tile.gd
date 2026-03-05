class_name Tile
extends Area2D

@export var marker: Marker2D
@export var highlight: ColorRect

var can_place = true
var current_plant: Plant
var silhouette_inst: Node2D

func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed
	):
		match  game_mngr.plant_mngr.click_type:
			
			game_mngr.plant_mngr.ClickTypes.none:
				return
				
			game_mngr.plant_mngr.ClickTypes.plant:
				game_mngr.plant_mngr._place_plant(self)
				
			game_mngr.plant_mngr.ClickTypes.shovel:
				if current_plant:
					game_mngr.plant_mngr.click_type = game_mngr.plant_mngr.ClickTypes.none
				_clear_tile()
				
				
		
	
func _connect_plant(new_plant: Plant):
	if new_plant == null:
		return
		
	current_plant = new_plant
	current_plant.health_component.died.connect(_clear_tile)
	
func _clear_tile():
	if current_plant:
		current_plant.queue_free()
		can_place = true
	

func _on_mouse_entered() -> void:
	
	if silhouette_inst:
		silhouette_inst.queue_free()
		silhouette_inst = null
	
	if (
		can_place and 
		game_mngr.plant_mngr.click_type == game_mngr.plant_mngr.ClickTypes.plant
		):
		
		silhouette_inst = game_mngr.plant_mngr.silhouettte.instantiate()
		
		silhouette_inst.global_position = marker.global_position
		game_mngr.current_scene.add_child(silhouette_inst)
		
	if(
		current_plant and 
		game_mngr.plant_mngr.click_type == game_mngr.plant_mngr.ClickTypes.shovel
	):
		
		current_plant.health_component.shader._set_white(0.25)
		

func _on_mouse_exited() -> void:
	
	if silhouette_inst:
		silhouette_inst.queue_free()
		silhouette_inst = null
		
	if current_plant:
		
		current_plant.health_component.shader._set_white(0)
