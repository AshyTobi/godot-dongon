extends Node2D


var cell_size = Vector2i(16,16)
var grid_size = Vector2i(15,15)
var grid = AStarGrid2D.new()
var start = Vector2i(randi_range(0,grid_size.x-1),grid_size.y-1)
var end = Vector2i(randi_range(0,grid_size.x-1),0)


func _ready():
	grid_init()
	for i in 80:
		place_wall()
	update_path()
	$Player.position = start*16 + Vector2i(8,8)


func grid_init():
	grid.region = Rect2i(Vector2i(0,0), grid_size)
	grid.cell_size = cell_size
	grid.offset = cell_size / 2
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()


func update_path():
	$Line2D.points = PackedVector2Array(grid.get_point_path(start, end))


func _input(event):
	if event is InputEventMouseButton:
		# Add/remove wall
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pos = Vector2i(get_global_mouse_position()) / cell_size
			if grid.is_in_boundsv(pos):
				grid.set_point_solid(pos, not grid.is_point_solid(pos))
			update_path()
			queue_redraw()


func place_wall():
	grid.set_point_solid(Vector2i(randi_range(0,grid_size.x-1),randi_range(1,grid_size.y-2)), true)


func _draw():
	draw_grid()
	fill_walls()


func draw_grid():
	draw_rect(Rect2(start * cell_size, cell_size), Color.GREEN_YELLOW)
	draw_rect(Rect2(end * cell_size, cell_size), Color.ORANGE_RED)
	for x in grid_size.x + 1:
		draw_line(Vector2(x * cell_size.x, 0),
			Vector2(x * cell_size.x, grid_size.y * cell_size.y),
			Color.DARK_GRAY, 1.0)
	for y in grid_size.y + 1:
		draw_line(Vector2(0, y * cell_size.y),
			Vector2(grid_size.x * cell_size.x, y * cell_size.y),
			Color.DARK_GRAY, 1.0)


func fill_walls():
	for x in grid_size.x:
		for y in grid_size.y:
			if grid.is_point_solid(Vector2i(x, y)):
				$TileMapLayer.set_cell(Vector2i(x,y), 0, Vector2i(4,3))
			else:
				$TileMapLayer.erase_cell(Vector2i(x,y))
				#draw_rect(Rect2(x * cell_size.x, y * cell_size.y, cell_size.x, cell_size.y), Color.DARK_GRAY)
