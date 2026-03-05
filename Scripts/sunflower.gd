extends Plant

@export var spawn_cooldown: int
@export var shader: ShaderComponent

@onready var spawn_timer = $SpawnTimer
@onready var shader_timer = $ShaderTimer
@onready var spawn_pos = $SpawnPos
@onready var sprite = $Sprite2D

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_cooldown
	spawn_timer.start()
	
	shader_timer.timeout.connect(_on_shader_timer_timeout)
	_start_shader_timer()
	
func _start_shader_timer():
	shader_timer.wait_time = spawn_cooldown - 1
	shader_timer.start()
	
func _on_spawn_timer_timeout() -> void:
	_spawn_sun()
	_start_shader_timer()
	
func _on_shader_timer_timeout():
	shader._set_yellow(0.15)
	
	
func _spawn_sun():
	var sun = preload("res://Scenes/Objects/sun.tscn")
	var new_sun: Sun = sun.instantiate()
	
	shader._set_yellow(0)
	
	new_sun.global_position = spawn_pos.global_position
	
	game_mngr.current_scene.add_child(new_sun)
	new_sun._spawn_from_sunflower()
