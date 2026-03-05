extends Node2D

class_name Zombie

@export var max_speed: int
@export var zombie_damage: int
@export var stage_manager: ZombieStageManager
@export var shader: ShaderComponent

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var detection_component: DetectionComponent = $DetectionComponent

var speed: int
var target_plant: Plant
var state:ZombieState = ZombieState.EAT
var current_stage: int = -1
var is_dead: bool = false
var stage_set: bool
var checks_cleared: bool

var overlapping_plants: Array[Plant] = []

enum ZombieState {
	WALK,
	EAT,
}

func _ready() -> void:
	speed = max_speed
	
	health_component.damage_taken.connect(_check_health)
	health_component.died.connect(_zombie_died)
	detection_component.target_connected.connect(_get_target)
	game_mngr.zombie_mngr.checks_cleared.connect(_clear_checks)
	
	_set_state(ZombieState.WALK)
	_check_health()
	
func _physics_process(delta: float) -> void:
		
	if state == ZombieState.WALK:
		global_position.x -= speed * delta

func _get_target():
	target_plant = detection_component.target_body
	
	if target_plant == null:
		_set_state(ZombieState.WALK)
		return
		
	_set_state(ZombieState.EAT)
	
func _set_state(new_state: ZombieState):
	if is_dead:
		return
		
	if state == new_state:
		return
		
	state = new_state
	
	match state:
		ZombieState.WALK:
			speed = max_speed
			animation_player.play("walk")
			
		ZombieState.EAT:
			speed = 0
			animation_player.play("eat")
			
	
func _eat_plant():
	if is_dead:
		return
		
	if state != ZombieState.EAT:
		return
	
	var plant_health:HealthComponent = target_plant.get_node("HealthComponent")
	plant_health._take_damage(zombie_damage)
	
	
func _check_health():
	if is_dead:
		return
		
	var new_stage = stage_manager._find_health_stage(
		health_component.health
	)
	
	if new_stage != current_stage:
		if stage_set and not checks_cleared:
			game_mngr.zombie_mngr._add_check(current_stage - new_stage)
			
		_set_stage(new_stage)
		
	
func _zombie_died():
	
	if is_dead:
		return
	
	is_dead = true
	
func _fall():
	
	if not is_dead:
		return
	
	speed = 0
	animation_player.play("fall")
	
	await animation_player.animation_finished
	
	var tween = shader.create_tween()
	tween.tween_method(
	shader._set_fade, 1.0, 0.0, 1.0
)
	
	tween.finished.connect(queue_free)
	
	
func _set_stage(new_stage: int):
	
	current_stage = new_stage
	stage_manager._spawn_object(current_stage, global_position)
	stage_set = true
	
	
func _clear_checks():
	checks_cleared = true
	
