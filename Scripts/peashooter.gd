extends Plant

@onready var detection_component : DetectionComponent = $DetectionComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $AttackCooldown
@onready var shooting_point: = $ShootingPoint


var off_cooldown: bool = true
var target_ready: bool

func _ready() -> void:
	
	timer.timeout.connect(_off_cooldown)
	detection_component.target_connected.connect(_target_connected)
	
func _shoot() -> void:

	off_cooldown = false
	timer.start()
	var pea = preload("res://Scenes/Objects/pea.tscn")
	var new_pea = pea.instantiate()
	new_pea.global_position = shooting_point.global_position
	game_mngr.current_scene.add_child(new_pea)
	animation_player.play("idle")


func _off_cooldown() -> void:
	off_cooldown = true
	_try_to_shoot()
	
func _target_connected():
	if detection_component.target_body == null:
		target_ready = false
		return
		
	target_ready = true
	_try_to_shoot()
	
func _try_to_shoot():
	if not off_cooldown:
		return
		
	if not target_ready:
		return
		
	animation_player.play("shoot")
	
