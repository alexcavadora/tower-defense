class_name MovementComponent
extends Node2D
signal path_completed
var current_path: Array[Vector2i]
@export var creature_speed = 0.75
var tm : TileMap
var starting_tile : Vector2i = Vector2i(0,0)
var finishing_tile : Vector2i = Vector2i(0,0)

func init(st, ft, tile):
	get_parent().global_position = tile.map_to_local(st)
	self.starting_tile = st
	self.finishing_tile = ft
	self.tm = tile
	self.current_path = tile.astar.get_id_path(st, ft).slice(1)

func _physics_process(_delta):
	if current_path.is_empty():
		emit_signal("path_completed")
		return

	var target_position = tm.map_to_local(current_path.front())
	get_parent().global_position = global_position.move_toward(target_position, creature_speed)

	if global_position == target_position:
		current_path.pop_front()
