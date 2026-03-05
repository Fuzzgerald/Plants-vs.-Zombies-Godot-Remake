extends Area2D

class_name DetectionComponent

@export var target_type: target_types
@export var max_x: int = 325

signal target_connected 

var pending_bodies: Array[Node2D] = []
var bodies_in_range: Array[Node2D] = []
var target_body: Node2D

enum target_types{
	plants,
	zombies
}

func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)
	
	
func _process(delta: float) -> void:
	if not pending_bodies:
		return
		
	var bodies_done_pending: Array[Node2D] = []
		
	for body in pending_bodies:
		if body.global_position.x < max_x:
			bodies_done_pending.append(body)
			
	for body in bodies_done_pending:
		_add_body(body)
		_remove_body(body)
	
	
func _add_body(body: Node2D):
	
	if not _valid_target(body):
		return
	
	if bodies_in_range.has(body):
		return
		
	bodies_in_range.append(body)
	_sort_bodies()
	_choose_target()
	
	
func _remove_body(body):
	
	if pending_bodies.has(body):
		pending_bodies.erase(body)
		return
	
	if bodies_in_range.has(body):
		bodies_in_range.erase(body)
		
	_sort_bodies()
	_choose_target()
	

func _valid_target(body: Node2D):
	
	match target_type:
		
		target_types.plants:
			return body.is_in_group("plants")
			
		target_types.zombies:
			return body.is_in_group("zombies")
	return false

func _area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	
	if body.global_position.x > max_x:
		if pending_bodies.has(body):
			return
			
		pending_bodies.append(body)
		return
	
	_add_body(body)
	
	
func _sort_bodies():
	if target_type == target_types.plants:
		bodies_in_range.sort_custom(
			func(a, b):
			return a.global_position.x > b.global_position.x
)
	
	if target_type == target_types.zombies:
		bodies_in_range.sort_custom(
			func(a, b):
			return a.global_position.x < b.global_position.x
)
	
func _area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	
	_remove_body(body)
	
	
func _choose_target():
	if bodies_in_range.is_empty():
		target_body = null
		target_connected.emit()
		return

	target_body = bodies_in_range[0]
	target_connected.emit()
	
