extends TileMap

var astar = AStarGrid2D.new()
var map_rect = Rect2i()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tile_size = get_tileset().tile_size
	var tilemap_size = get_used_rect().end - get_used_rect().position
	map_rect = Rect2i(Vector2i(), tilemap_size)
	
	astar.region = map_rect
	astar.cell_size = tile_size
	astar.offset = tile_size * 0.5
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in tilemap_size.x:
		for j in tilemap_size.y:
			var coordinates = Vector2i(i, j)
			var tile_data = get_cell_tile_data(1, coordinates)
			if tile_data and tile_data.get_custom_data('type'):
				astar.set_point_solid(coordinates)
	create_optimal_path(Vector2i(0,2), Vector2i(19,7))
	create_optimal_path(Vector2i(9,0), Vector2i(19,7))
	
func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if map_rect.has_point(map_position):
		return not astar.is_point_solid(map_position)
	return false
	
func create_optimal_path(starting_tile: Vector2i , finising_tile: Vector2i):
	if astar.is_point_solid(starting_tile) or astar.is_point_solid(finising_tile):
		return
	
	var path = astar.get_id_path(starting_tile, finising_tile)
	set_cells_terrain_path(2, path, 2, 0)
	set_cells_terrain_path(1, path, 1, 0)
	#checking adjacent 
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
	if(get_cell_source_id(2,Vector2(cell.x+1,cell.y)) == 1):
		return 'right'
	if(get_cell_source_id(2,Vector2(cell.x-1,cell.y)) == 1):
		return 'left'
	if (get_cell_source_id(2,Vector2(cell.x,cell.y-1)) == 1):
		return 'up'
	if (get_cell_source_id(2,Vector2(cell.x,cell.y+1)) == 1):
		return 'down'
