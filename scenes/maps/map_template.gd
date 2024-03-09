extends TileMap

var astar = AStarGrid2D.new()
var map_rect = Rect2i()
@export var finishing_tile = Vector2i(0,0)
@export var starting_tile : Array[Vector2i] = [Vector2i()]
var tile_size
var tilemap_size

func _ready():
	tile_size = get_tileset().tile_size
	tilemap_size = get_used_rect().end - get_used_rect().position
	map_rect = Rect2i(Vector2i(0,0), tilemap_size)
	
	astar.region = map_rect
	astar.cell_size = tile_size
	astar.offset = tile_size * 0.5
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	update()

func update():
	for i in tilemap_size.x:
		for j in tilemap_size.y:
			var coordinates = Vector2i(i, j)
			var tile_data = get_cell_tile_data(1, coordinates)
			if tile_data and tile_data.get_custom_data('solid'):
				astar.set_point_solid(coordinates)
	clear_layer(2)
	for i in starting_tile:
		create_optimal_path(i, finishing_tile)

func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if map_rect.has_point(map_position):
		return not astar.is_point_solid(map_position)
	return false
	
func create_optimal_path(start: Vector2i , finish: Vector2i):
	var path = astar.get_id_path(start, finish)
	if path.size() == 0 or astar.is_point_solid(start) or astar.is_point_solid(finish):
		return false
	set_cells_terrain_path(2, path, 2, 0) # drawing the arrows
	set_cells_terrain_path(1, path, 1, 0) # drawing the road on the ground
	
	# checking adjacent for the first position to override a weird bug in autotiling
	var cell = path.front()
	var origin_direction = find_origin_direction(cell)
	if origin_direction == 'left':
		set_cell(2, cell, 1, Vector2i(3,2))
	elif origin_direction == 'right':
		set_cell(2, cell, 1, Vector2i(3,1))
	elif origin_direction == 'up':
		set_cell(2, cell, 1, Vector2i(4,1))
	elif origin_direction == 'down':
		set_cell(2, cell, 1, Vector2i(4,0))

func find_origin_direction(cell):
	if cell:
		if(get_cell_source_id(2,Vector2(cell.x+1,cell.y)) == 1):
			return 'right'
		if(get_cell_source_id(2,Vector2(cell.x-1,cell.y)) == 1):
			return 'left'
		if (get_cell_source_id(2,Vector2(cell.x,cell.y-1)) == 1):
			return 'up'
		if (get_cell_source_id(2,Vector2(cell.x,cell.y+1)) == 1):
			return 'down'
	return 'right'

func _unhandled_input(_event):
	if Input.is_action_pressed("click"):
		var pos = local_to_map(get_global_mouse_position())
		set_cell(1, pos, 0, Vector2i(0,13))
		#for i in starting_tile:
			#if !create_optimal_path(i,finishing_tile):
					#set_cell(1, pos, -1, Vector2i(-1,-1))
		update()
