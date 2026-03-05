extends Node2D

var plant_mngr: PlantPlacementManager
var zombie_mngr: ZombieManager

var current_scene: Node2D

@export var load_scene: PackedScene

func _ready() -> void:
	_load_scene(load_scene)

func _clear_scene():
	if current_scene:
		current_scene.queue_free()
		await current_scene.tree_exited
		
		plant_mngr = null
		zombie_mngr = null

func _load_scene(scene: PackedScene):
	_clear_scene()
	await _clear_scene()
	
	var scene_inst = scene.instantiate()
	add_child(scene_inst)
	current_scene = scene_inst
	
