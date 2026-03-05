extends Node2D

class_name ZombieObject

@export var arc_distance: float 
@export var arc_y_offset: float 
@export var arc_height: float 
@export var arc_duration: float 
@export var rotation_amount: float = 180

@onready var sprite: Node2D = $Sprite2D

var start_pos: Vector2
var target_pos: Vector2


func _ready() -> void:
	launch_arc()


func launch_arc() -> void:
	var extra_distance = randf_range(0.7, 1)

	start_pos = sprite.position
	target_pos = sprite.position + Vector2(
		arc_distance * extra_distance,
		arc_y_offset
	)

	var tween := create_tween()

	tween.tween_method(
		_create_arc,
		0.0,
		1.0,
		arc_duration
	)

	if rotate:
		tween.parallel().tween_property(
			sprite,
			"rotation_degrees",
			rotation_degrees + rotation_amount,
			arc_duration
		)

	tween.finished.connect(_on_arc_finished)


func _create_arc(progress: float) -> void:
	var x = lerp(start_pos.x, target_pos.x, progress)
	var y = lerp(start_pos.y, target_pos.y, progress)
	y -= sin(progress * PI) * arc_height

	sprite.position = Vector2(x, y)


func _on_arc_finished() -> void:
	var fade_tween = create_tween()
	fade_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		1
	)
	fade_tween.finished.connect(queue_free)
