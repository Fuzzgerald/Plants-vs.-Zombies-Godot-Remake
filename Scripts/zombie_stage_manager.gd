extends Node2D

class_name ZombieStageManager

@export var stages: Array[StageData]
@export var sprites: Array[Sprite2D]

func _ready() -> void:
	for i in stages.size():
		stages[i] = stages[i].duplicate(true)
		
	for stage in stages:
		if stage.spawns_object:
			stage.spawn_stage = stages.find(stage)

func _find_health_stage(current_health: int):
	for stage in stages.size():
		
		if current_health <= stages[stage].stage_health:
			
			_enable_sprite(stage)
			
			return stage
			
			
func _enable_sprite(value: int):
	for sprite in sprites.size():
		if sprite == value:
			sprites[sprite].visible = true
		else:
			sprites[sprite].visible = false
	
func _spawn_object(stage_value: int, spawn_position: Vector2):
	
	for stage in stages:
		if not stage.spawns_object:
			continue
		
		if stage.object_type == null:
			continue
			
		if stage.has_spawned:
			continue
		
		if stage.spawn_stage >= stage_value:
			var new_object = stage.object_type.instantiate()
			new_object.global_position = spawn_position
			stage.has_spawned = true
	
			game_mngr.current_scene.add_child(new_object)
	
