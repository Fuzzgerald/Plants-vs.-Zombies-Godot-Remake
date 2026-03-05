extends Node2D

class_name HealthComponent

@export var max_health: int
@export var shader: ShaderComponent

var health: int
var timer: SceneTreeTimer

signal damage_taken
signal died

func _ready() -> void:
	health = max_health
	
func _take_damage(damage: int):
	health -= damage
	emit_signal("damage_taken")
	_white_flash()
	if health <= 0:
		emit_signal("died")

func _white_flash():
	
	shader._set_white(0.5)
	
	if timer:
		timer.disconnect("timeout", _end_flash)

	timer = get_tree().create_timer(0.2)
	timer.timeout.connect(_end_flash)

func _end_flash():
	shader._set_white(0)
	timer = null
