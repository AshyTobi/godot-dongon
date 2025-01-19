extends Node2D


class Room:
	var pos: Vector2i
	var doors = {"north": false, "east": false, "south": false, "west": false}


@onready var roomsToGenerate: Array = []
@onready var roomPositions = {}
@onready var roomAmount = 17


func _ready():
	var room = Room.new()
	room.pos = Vector2i(0,0)
	roomPositions[room.pos] = true
	roomsToGenerate.append(room)
	generate_dungeon()


# generates roomAmount rooms + a few extra
func generate_dungeon():
	for i in roomAmount:
		open_doors(roomsToGenerate[i])


# tries to open the door in all cardinal directions with a 50% chance
# and generates a new room in that direction if possible
func open_doors(room):
	for direction in room.doors:
		# this part needs to be refined
		# current chance is 50% for all doors, should be flexable
		# there is a possibility, that all doors are closed.
		# at least one should be open 
		if room.doors[direction]:
			continue
		room.doors[direction] = randi_range(1,100) <= 40
		if room.doors[direction] and !room_exists(direction, room.pos):
			create_new_room(direction, room.pos)


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
		#print("nl")
