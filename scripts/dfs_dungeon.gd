extends Node2D


class Room:
	var pos: Vector2i
	var doors = {"north": false, "east": false, "south": false, "west": false}


@onready var roomsToGenerate: Array = []
@onready var roomPositions = {}
var roomAmount = 20


func _ready():
	var room = Room.new()
	room.pos = Vector2i(0,0)
	roomPositions[room.pos] = true
	roomsToGenerate.append(room)
	generate_dungeon()


func generate_dungeon():
	for i in roomAmount:
		open_doors(roomsToGenerate[i])


# TODO
# still not very satisfing how this gets generated. i'm sad.
func open_doors(room):
	var possibleDirections = []
	var openRandomAmount = 0
	for direction in room.doors:
		if !room.doors[direction] and !room_exists(direction, room.pos):
			possibleDirections.append(direction)
	
	if !possibleDirections.is_empty():
		openRandomAmount = randi_range(0,possibleDirections.size())
	
	for i in openRandomAmount:
		var randomDirection = possibleDirections.pick_random()
		possibleDirections.erase(randomDirection)
		create_new_room(randomDirection, room.pos)


func room_exists(direction, pos) -> bool:
	var result: bool = false
	match direction:
		"north": result = roomPositions.has(pos + Vector2i.UP)
		"east": result = roomPositions.has(pos + Vector2i.RIGHT)
		"south": result = roomPositions.has(pos + Vector2i.DOWN)
		"west": result = roomPositions.has(pos + Vector2i.LEFT)
	return result


func create_new_room(direction, pos):
	var newRoom = Room.new()
	var newPos: Vector2i
	match direction:
		"north":
			newPos = pos + Vector2i.UP
			newRoom.doors["south"] = true
		"east":
			newPos = pos + Vector2i.RIGHT
			newRoom.doors["west"] = true
		"south":
			newPos = pos + Vector2i.DOWN
			newRoom.doors["north"] = true
		"west":
			newPos = pos + Vector2i.LEFT
			newRoom.doors["east"] = true
	newRoom.pos = newPos
	roomPositions[newPos] = true
	roomsToGenerate.append(newRoom)


func _draw():
	for i in roomsToGenerate.size():
		draw_rect(Rect2i(roomsToGenerate[i].pos * Vector2i(16,16), Vector2i(16,16)), Color.PURPLE, false, 1)
		draw_string(ThemeDB.fallback_font,roomsToGenerate[i].pos * Vector2i(16,16) + Vector2i(4,12),str(i),HORIZONTAL_ALIGNMENT_LEFT,-1,12)
		print("nl")
