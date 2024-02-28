extends CharacterBody2D

var current_path: Array[Vector2i]
@onready var tilemap = $"../Ground"
@export var starting_tile = Vector2i(0,0) #tilemap.starting_tile
var creature_speed = 0.75
 
var finising_tile
func _ready():
	$AnimatedSprite2D.play()
	position = tilemap.map_to_local(starting_tile)
	finising_tile = tilemap.finishing_tile
	current_path = tilemap.astar.get_id_path(starting_tile, finising_tile).slice(1)

func _physics_process(_delta):
	if current_path.is_empty():
		$AnimatedSprite2D.stop()
		return
	var target_position = tilemap.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, creature_speed)
	
	if global_position == target_position:
		current_path.pop_front()
