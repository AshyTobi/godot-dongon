extends Node2D


class Room:
	var pos: Vector2i
	var doors = {"north": false, "east": false, "south": false, "west": false}
	var north: Room = null
	var east: Room = null
	var south: Room = null
	var west: Room = null


var roomPositions = {}
var roomAmount = 33
var openingChance = 50
var rooms: Array[Room] = []


func _ready():
	#generate_dungeon_A()
	#generate_dungeon_B()
	generate_dungeon_C()
	open_random_doors()
	print(rooms.size())


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			roomPositions.clear()
			rooms.clear()
			generate_dungeon_A()
			open_random_doors()
			queue_redraw()
			print("Dungeon A Generated")
			print(rooms.size())
		if event.keycode == KEY_2:
			roomPositions.clear()
			rooms.clear()
			generate_dungeon_B()
			open_random_doors()
			queue_redraw()
			print("Dungeon B Generated")
			print(rooms.size())
		if event.keycode == KEY_3:
			roomPositions.clear()
			rooms.clear()
			generate_dungeon_C()
			open_random_doors()
			queue_redraw()
			print("Dungeon C Generated")
			print(rooms.size())


func generate_dungeon_C():
	var i: int = 0
	var dirCount: int = 0
	var validDirections: Array
	var direction: String = ""
	create_room(Vector2i(0,0), direction)
	while true:
		if rooms.size() >= roomAmount:
			break
		validDirections = get_valid_directions(rooms[i])
		dirCount = validDirections.size()
		for n in dirCount:
			if rooms.size() >= roomAmount:
				break
			direction = get_random_direction(validDirections)
			validDirections.erase(direction)
			if randi_range(1,100) <= openingChance:
				rooms[i].doors[direction] = true
				create_room(rooms[i].pos, direction)
		if i < rooms.size() - 1:
			i += 1
		else:
			while i >= 0 and get_valid_directions(rooms[i]).size() == 0:
				i -= 1


func generate_dungeon_B():
	var counter = 0
	var breaker = roomAmount
	create_room(Vector2i(0,0), "")
	for i in roomAmount:
		if i == rooms.size() or i > breaker:
			breaker = roomAmount + 1
			counter = 0
		var validDirections = get_valid_directions(rooms[counter])
		if !validDirections.is_empty():
			var randomDirection = get_random_direction(validDirections)
			rooms[counter].doors[randomDirection] = true
			create_room(rooms[counter].pos, randomDirection)
		counter += 1


func generate_dungeon_A():
	create_room(Vector2i(0,0), "")
	var validDirections: Array
	while rooms.size() < roomAmount:
		for i in rooms.size():
			if rooms.size() >= roomAmount:
				break
			validDirections = get_valid_directions(rooms[i])
			if !validDirections.is_empty() and randi_range(1,100) < openingChance:
				var randomDirection = get_random_direction(validDirections)
				rooms[i].doors[randomDirection] = true
				create_room(rooms[i].pos, randomDirection)


func create_room(pos: Vector2i, direction: String) -> void:
	var room = Room.new()
	room.pos = get_new_room_position(pos, direction)
	if !direction.is_empty():
		match direction:
			"north": room.doors["south"] = true
			"east" : room.doors["west"] = true
			"south": room.doors["north"] = true
			"west" : room.doors["east"] = true
	roomPositions[room.pos] = true
	rooms.append(room)


func open_random_doors() -> void:
	var door_options: Array = []
	for i in rooms.size():
		door_options = get_opening_directions(rooms[i])
		for door in door_options:
			if randi_range(1,100) <= 20:
				rooms[i].doors[door] = true


func get_opening_directions(room: Room) -> Array:
	var result: Array = []
	for direction in room.doors:
		if !room.doors[direction] and room_exists(get_new_room_position(room.pos, direction)):
			result.append(direction)
	return result


func get_random_direction(directions: Array) -> String:
	return directions.pick_random()


func get_new_room_position(pos: Vector2i, direction: String) -> Vector2i:
	var result: Vector2i
	match direction:
		"north": result = pos + Vector2i.UP
		"east" : result = pos + Vector2i.RIGHT
		"south": result = pos + Vector2i.DOWN
		"west" : result = pos + Vector2i.LEFT
	return result


func get_valid_directions(room: Room) -> Array:
	var result: Array = []
	for direction in room.doors:
		if !room.doors[direction] and !room_exists(get_new_room_position(room.pos, direction)):
			result.append(direction)
	return result


func room_exists(pos: Vector2i) -> bool:
	return roomPositions.has(pos)


func get_vector_from_direction(dir: String) -> Vector2i:
	var result: Vector2i
	match dir:
		"north": result = Vector2i.UP
		"east" : result = Vector2i.RIGHT
		"south": result = Vector2i.DOWN
		"west" : result = Vector2i.LEFT
		_: result = Vector2i.ZERO
	return result


func _draw():
	var size = Vector2i(32,32)
	var step_size = 1.0 / float(roomAmount)
	#draw_string(ThemeDB.fallback_font, Vector2i(1,10), "start",HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
	for i in rooms.size():
		draw_rect(Rect2(rooms[i].pos * size,size),Color(step_size*i,0,step_size*i))
		for dir in rooms[i].doors:
			if rooms[i].doors[dir]:
				draw_line(rooms[i].pos * size + Vector2i(16,16), rooms[i].pos * size + Vector2i(16,16)
				+ get_vector_from_direction(dir) * Vector2i(16,16), Color.GREEN, 2)
		draw_string(ThemeDB.fallback_font, rooms[i].pos * size + Vector2i(8,20), str(i),
		HORIZONTAL_ALIGNMENT_CENTER, -1, 12)
