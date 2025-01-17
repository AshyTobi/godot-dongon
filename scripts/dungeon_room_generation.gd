extends Node2D

var level_size = 5

func _ready():
	var id = 0
	for x in level_size:
		for y in level_size:
			generate_room(x,y, id)
	$Player.global_position = Vector2i(16*16*2.5+8, 16*16*4.5+8)
	
	print($tilemap.local_to_map(Vector2i(40,40)))


func generate_room(_x, _y, _id):
	var pos: Vector2i
	for x in 17:
		for y in 17:
			pos = Vector2i(x + 16 * _x,y + 16 * _y)
			if x == 0 or x == 16 or y == 0 or y == 16:
				$tilemap.set_cell(pos, _id, Vector2i(4,3))
			else:
				$tilemap.set_cell(pos, _id, Vector2i(0,4))
	
	if _y > 0:
		#north
		$tilemap.set_cell(Vector2i(8 + 16 * _x,0 + 16 * _y), _id, Vector2i(9,0))
	if _x > 0:
		#west
		$tilemap.set_cell(Vector2i(0 + 16 * _x,8 + 16 * _y), _id, Vector2i(9,0))
	if _x < level_size-1:
		#east
		$tilemap.set_cell(Vector2i(16+ 16 * _x,8 + 16 * _y), _id, Vector2i(9,0))
	if _y < level_size-1:
		#south
		$tilemap.set_cell(Vector2i(8 + 16 * _x,16 + 16 * _y), _id, Vector2i(9,0))
