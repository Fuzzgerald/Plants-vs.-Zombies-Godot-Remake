extends Node2D

@onready var text: Label = $Label

func _process(delta: float) -> void:
	text.text = str(game_mngr.plant_mngr.total_sun)
