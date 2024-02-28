extends CharacterBody2D

var current_path: Array[Vector2i]
@onready var tilemap = $"../Ground"
@export var starting_position = Vector2i(0,0)
var finish_position
func _ready():
	$AnimatedSprite2D.play()
	current_path = tilemap.astar.get_id_path(starting_position, finish_position).slice(1)

func _physics_process(_delta):
	if current_path.is_empty():
		return
		
	var target_position = tilemap.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
		current_path.pop_front()
