extends Plant

enum damage_state {
	FULL,
	CRACKED,
	BROKEN,
}

var state: damage_state = damage_state.FULL

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	health_component.damage_taken.connect(_check_health)
	_check_health()

func _check_health():
	var current_health = health_component.health
	var cracked_health = health_component.max_health * 0.66
	var broken_health = health_component.max_health * 0.33
	
	if current_health > cracked_health:
		_set_state(damage_state.FULL)
	elif current_health > broken_health:
		_set_state(damage_state.CRACKED)
	else:
		_set_state(damage_state.BROKEN)
		
	
	
	
func _set_state(new_state: damage_state):
	if state == new_state:
		return
		
	var progress = animation_player.current_animation_position
	state = new_state
	
	match state:
		
		damage_state.FULL:
			animation_player.play("full_idle")
			
		damage_state.CRACKED:
			animation_player.play("cracked_idle")
			
		damage_state.BROKEN:
			animation_player.play("broken_idle")
			
	animation_player.seek(progress, true)
