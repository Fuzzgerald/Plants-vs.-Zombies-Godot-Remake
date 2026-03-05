extends Area2D

@export var health_component: HealthComponent

var flash_tween: Tween

func _hurt_box_connected(area: Area2D) -> void:
	if area is HurtBox:
		health_component._take_damage(area.damage)
		
