extends Node2D

var paused: bool

@onready var pause_menu: Control = $PauseMenu

func _pause_game():
	if paused:
		get_tree().paused = false
		pause_menu.visible = false
		paused = false
		return
		
	get_tree().paused = true
	pause_menu.visible =true
	paused = true
	
func _unpause():
	if paused:
		get_tree().paused = false
		pause_menu.visible = false
		paused = false
	
