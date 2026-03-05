extends Node2D

class_name ZombieSpawner

@export var quick_wait: float
@export var regular_wait: float

@onready var timer : Timer = $Timer
@onready var spawn_point := $SpawnPoint

var zombie_queue: Array[PackedScene] = []

var zombie_count: int

func _ready() -> void:
	timer.timeout.connect(_timer_ended)
	game_mngr.zombie_mngr._register_lane(self)

func _get_zombie(new_zombie: PackedScene):
	
	if not new_zombie:
		return
		
	zombie_queue.append(new_zombie)
	zombie_count += 1
	
	if timer.is_stopped():
		_start_timer(quick_wait)
	
func _start_timer(wait: float):
	
	timer.wait_time = randf_range(wait -1.5, wait +1.5)
	timer.start()
	
func _timer_ended():
	
	_spawn_next_zombie()
	
func _spawn_next_zombie():
	
	var new_zombie = zombie_queue.pop_front()
	var zombie = new_zombie.instantiate()
	
	zombie.global_position = spawn_point.global_position
	game_mngr.current_scene.add_child(zombie)
	
	if zombie_queue.is_empty():
		timer.stop()
	else:
		_start_timer(regular_wait)
	
	
	
