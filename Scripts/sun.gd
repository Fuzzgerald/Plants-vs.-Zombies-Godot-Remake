class_name Sun
extends Area2D

@export var fall_speed:int
@export var arc_height: int
@export var arc_distance: int
@export var arc_y_offset: int
@export var arc_duration: float
@export var lifetime: float
@export var fade_duration: float

var sun_value = 25
var start_pos: Vector2
var target_pos: Vector2

@onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = lifetime
	timer.timeout.connect(_on_timer_timeout)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton 
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed
	):
		game_mngr.plant_mngr.gain_sun(sun_value)
		
		viewport.set_input_as_handled()
		queue_free()


func _fall_from_sky(landing_height: float):
	
	var distance = abs(global_position.y - landing_height)
	var fall_time = distance / fall_speed
	
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", landing_height, fall_time)
	tween.finished.connect(_start_countdown)


func _spawn_from_sunflower():
	
	var direction = randf_range(-1, 1)
	var new_arc_distance = arc_distance * direction
	
	start_pos = global_position
	target_pos.x = global_position.x + new_arc_distance
	target_pos.y = global_position.y + arc_y_offset
	
	var tween = create_tween()
	tween.tween_method(
		_create_arc,
		0.0,
		1.0,
		arc_duration
	)
	tween.finished.connect(_start_countdown)
	
func _create_arc(progress: float):
	var x = lerp(start_pos.x, target_pos.x, progress)
	
	var y = lerp(start_pos.y, target_pos.y, progress)
	y -= sin(progress * PI) * arc_height
	
	global_position = Vector2(x, y)
	
	
func _start_countdown():
	timer.start()


func _on_timer_timeout() -> void:
	var fade_tween = create_tween()
	fade_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		fade_duration
	)
	fade_tween.finished.connect(queue_free)
