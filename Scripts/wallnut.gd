extends Plant

enum DamageState {
	FULL,
	CRACKED,
	BROKEN,
}

var state: DamageState = DamageState.FULL

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	health_component.damage_taken.connect(_check_health)
	_check_health()

func _check_health():
	var current_health = health_component.health
	var cracked_health = health_component.max_health * 0.66
	var broken_health = health_component.max_health * 0.33
	
	if current_health > cracked_health:
		_set_state(DamageState.FULL)
	elif current_health > broken_health:
		_set_state(DamageState.CRACKED)
	else:
		_set_state(DamageState.BROKEN)
		
	
	
	
func _set_state(new_state: DamageState):
	if state == new_state:
		return
		
	var progress = animation_player.current_animation_position
	state = new_state
	
	match state:
		
		DamageState.FULL:
			animation_player.play("full_idle")
			
		DamageState.CRACKED:
			animation_player.play("cracked_idle")
			
		DamageState.BROKEN:
			animation_player.play("broken_idle")
			
	animation_player.seek(progress, true)
