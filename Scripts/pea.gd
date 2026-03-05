extends Node2D

@export var speed: int
@export var damage: int = 20

@onready var detection_component = $DetectionComponent

func _ready() -> void:
	detection_component.target_connected.connect(_on_hit)

func _physics_process(delta: float) -> void:
	global_position.x += speed * delta

func _on_hit() -> void:
	
	var hit_zombie: Node2D = detection_component.target_body
	
	if hit_zombie == null:
		return
		
	if not hit_zombie.has_node("HealthComponent"):
		return
	
	var zombie_health: HealthComponent = hit_zombie.get_node("HealthComponent")
	zombie_health._take_damage(damage)
	queue_free()
