extends Node2D

var level_size = 5
var room_size = Vector2i(8,6)


#-----------------------------------
#	nah man, cant care right now.
#	needs to be rewritten
#-----------------------------------
func _ready():
	var id = 0
	for x in level_size:
		for y in level_size:
			generate_room(x,y, id)
	#$Player.global_position = Vector2i(16*16*(level_size/2)+8, 16*16*4.5+8)



func generate_room(_x, _y, _id):
	var pos: Vector2i
	for x in room_size.x:
		for y in room_size.y:
			pos = Vector2i(x + (room_size.x) * _x, y + (room_size.y) * _y)
			if x == 0 or x == room_size.x-1 or y == 0 or y == room_size.y-1:
				$tilemap.set_cell(pos, _id, Vector2i(4,3))
			else:
				$tilemap.set_cell(pos, _id, Vector2i(6,3))
