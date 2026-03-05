extends Control

class_name SeedPacket

@export var plant_type: PackedScene
@export var sun_cost: int
@export var cooldown_time: float
@export var silhouette: PackedScene

@onready var timer = $CooldownTimer
@onready var label: Label = $Label
@onready var shader: ShaderComponent = $ShaderComponent

var can_afford: bool
var on_cooldown: bool = false
var is_selected: bool 


func _ready() -> void:
	label.text = str(sun_cost)
	timer.wait_time = cooldown_time
	timer.timeout.connect(_cooldown_finished)
	game_mngr.plant_mngr.value_changed.connect(_check_state)
	
	_check_state()
	
	
func _process(_delta: float) -> void:
	if on_cooldown:
		shader._set_cooldown(timer.time_left / timer.wait_time)
	else:
		shader._set_cooldown(0)
		
	if can_afford:
		label.modulate = Color.BLACK
		if not on_cooldown:
			shader._set_grey(0)
	else:
		label.modulate = Color.DARK_RED
		shader._set_grey(0.35)
		
	if is_selected:
		shader._set_white(0.25)
	else:
		shader._set_white(0)
	
	
func _on_gui_input(event: InputEvent) -> void:
	
	if can_afford == false or on_cooldown == true:
		return
	
	if(event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed
	):
		if is_selected:
			game_mngr.plant_mngr._change_click(game_mngr.plant_mngr.click_types.none)
		else:
			game_mngr.plant_mngr._get_new_plant(self)
		
	else:
		return
		
		
func _check_state():
	
	if game_mngr.plant_mngr.total_sun >= sun_cost:
		can_afford = true
	else: 
		can_afford = false
		
	if game_mngr.plant_mngr.seed_packet == self:
		is_selected = true
	else:
		is_selected = false
	
	
func _start_cooldown():
	
	timer.start()
	on_cooldown = true
			
			
func _cooldown_finished():
	on_cooldown = false
	
	
