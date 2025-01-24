extends Node2D


class Room:
	var pos: Vector2i
	var doors = {"north": false, "east": false, "south": false, "west": false}


var roomPositions = {}
var roomAmount = 50
var openingChance = 33
var rooms: Array[Room] = []


func _ready():
	#generate_dungeon_A()
	generate_dungeon_B()
	print(rooms.size())


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			print("shoot")
			roomPositions.clear()
			rooms.clear()
			generate_dungeon_A()
			queue_redraw()
			print(rooms.size())
		if event.keycode == KEY_2:
			print("shoot")
			roomPositions.clear()
			rooms.clear()
			generate_dungeon_B()
			queue_redraw()
			print(rooms.size())


func generate_dungeon_B():
	var counter = 0
	var breaker = roomAmount/2
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


func _draw():
	var step_size = 1.0 / float(roomAmount)
	draw_string(ThemeDB.fallback_font, Vector2i(1,10), "start",HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
	for i in rooms.size():
		draw_rect(Rect2(rooms[i].pos * Vector2i(32,32),Vector2i(32,32)),Color(step_size*i,0,step_size*i))
		draw_string(ThemeDB.fallback_font, rooms[i].pos * Vector2i(32,32) + Vector2i(8,20), str(i),
		HORIZONTAL_ALIGNMENT_CENTER, -1, 12)
