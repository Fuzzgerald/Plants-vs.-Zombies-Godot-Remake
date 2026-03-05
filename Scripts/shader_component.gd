class_name ShaderComponent
extends Node2D

@export var affected_sprites: Array[CanvasItem]

@export var shader: Material

func _ready() -> void:
	
	for sprite in affected_sprites:
		sprite.material = shader.duplicate()
		
	
func _set_white(amount: float):
	for sprite in affected_sprites:
		sprite.material.set_shader_parameter("white_tint", amount)
		
func _set_grey(amount: float):
	for sprite in affected_sprites:
		sprite.material.set_shader_parameter("grey_tint", amount)
		
func _set_yellow(amount: float):
	for sprite in affected_sprites:
		sprite.material.set_shader_parameter("yellow_tint", amount)
		
func _set_cooldown(amount: float):
	for sprite in affected_sprites:
		sprite.material.set_shader_parameter("cooldown_ratio", amount)
		
func _set_fade(amount: float):
	for sprite in affected_sprites:
		sprite.material.set_shader_parameter("fade_ratio", amount)
		
func _set_progress(amount: float):
	for sprite in affected_sprites:
		sprite.material.set_shader_parameter("progress_ratio", amount)
