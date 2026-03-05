extends Marker2D

@export var starting_height: Marker2D
@export var spawn_pos_x: Marker2D
@export var spawn_pos_y: Marker2D
@export var timer: Timer
@export var min_spawn_time: int
@export var max_spawn_time: int

func _start_timer():
	timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	timer.start()

func _on_timer_timeout() -> void:
	_create_sun()
	_start_timer()
	
func _create_sun():
	var sun = preload("res://Scenes/Objects/sun.tscn")
	var new_sun: Sun = sun.instantiate()
	new_sun.global_position.y = starting_height.global_position.y
	new_sun.global_position.x = randf_range(
		self.global_position.x, 
		spawn_pos_x.global_position.x
	)
	
	game_mngr.current_scene.add_child(new_sun)
	
	var landing_point = randf_range(
		self.global_position.y, 
		spawn_pos_y.global_position.y
	)
	
	new_sun._fall_from_sky(landing_point)
