class_name PlantPlacementManager
extends Node2D

signal value_changed

enum click_types {
	none, 
	plant,
	shovel
}

var total_sun: int = 50
var plant_cost: int
var seed_packet: SeedPacket
var plant_type: PackedScene
var silhouettte: PackedScene
var click_type: click_types

func _ready() -> void:
	game_mngr.plant_mngr = self

func gain_sun(sun_amount:int):
	total_sun += sun_amount
	value_changed.emit()

func _place_plant(tile: Tile):
	if tile.can_place == false:
		return
		
	if plant_type == null:
		return
		
	if total_sun < plant_cost:
		return
	
	var plant = plant_type.instantiate()
	plant.global_position = tile.marker.global_position
	game_mngr.current_scene.add_child(plant)
	
	seed_packet._start_cooldown()
	tile.silhouette_inst.queue_free()
	tile.can_place = false
	tile._connect_plant(plant)
	
	total_sun -= plant_cost
	_change_click(click_types.none)
	
	value_changed.emit()
	

func _get_new_plant(new_seed: SeedPacket):
	if new_seed == seed_packet:
		return
	
	seed_packet = new_seed
	plant_cost = seed_packet.sun_cost
	plant_type = seed_packet.plant_type
	silhouettte = seed_packet.silhouette
	_change_click(click_types.plant)
	
	value_changed.emit()
	
func _clear_current_plant():
	seed_packet = null
	plant_cost = 0
	plant_type = null
	silhouettte = null
	
	value_changed.emit()
	
func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_RIGHT
	and event.pressed
	):
		#_change_click(click_types.none)
		pass
	
func _change_click(type: click_types):
	
	click_type = type
	
	match click_type:
		
		click_types.none:
			_clear_current_plant()
			
		click_types.shovel:
			_clear_current_plant()

