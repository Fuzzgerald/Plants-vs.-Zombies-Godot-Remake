class_name ZombieManager
extends Node2D

signal checks_cleared

@export var wave_preset: WavePreset

var total_checks: int
var checks_reached: int
var required_checks: float
var wave_index: int
var current_wave: Wave
var amount_of_waves: int
var progress: float = 0.0

var zombies: Array[ZombieData] = []
var lanes: Array[ZombieSpawner] = []

@onready var timer:= $Timer

func _ready() -> void:
	game_mngr.zombie_mngr = self
	timer.timeout.connect(_start_next_wave)
	amount_of_waves = wave_preset.waves.size()

func _register_lane(lane: ZombieSpawner):
	if lanes.has(lane):
		return
		
	lanes.append(lane)
	
	
func _pick_lane():
	var shufled_lanes = lanes.duplicate()
	shufled_lanes.shuffle()
	var lane1 = shufled_lanes[0]
	var lane2 = shufled_lanes[1]
	
	
	if lane1.zombie_count <= lane2.zombie_count:
		return lane1
	else:
		return lane2

func _distribute_zombies():
	for zombie in zombies:
		var new_zombie = zombie.zombie_type
		var lane = _pick_lane()
		lane._get_zombie(new_zombie)
		
		
func _add_check(checks: int):
	
	checks_reached += checks
	
	if checks_reached >= required_checks:
		_start_next_wave()
	
	
func _start_next_wave():
	if progress >= 1:
		return
	
	current_wave = wave_preset.waves[wave_index]
	wave_index += 1
	progress = float(wave_index) / float(amount_of_waves) 
	_initialize_wave()
	
func _initialize_wave():
	
	total_checks = 0
	checks_reached = 0
	checks_cleared.emit()
	
	zombies = current_wave.zombies.duplicate()
	
	for zombie in zombies:
		total_checks += zombie.checks
		
	required_checks = total_checks * current_wave.amount_of_checks
	
	if current_wave.can_autostart:
		timer.wait_time = current_wave.time_delay
		timer.start()
		
	_distribute_zombies()
