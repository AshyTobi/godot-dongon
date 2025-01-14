extends Node2D


const DUNGEON_SIZE: Vector2i = Vector2i(368, 384)
const MIN_ROOM_SIZE: int = 16
const VARIATION: Vector2 = Vector2(0.4, 0.6)

class Dungeon:
	var room: Rect2i
	var door: Rect2i
	var leftSection: Dungeon
	var rightSection: Dungeon

var level = Dungeon.new()


func _ready():
	randomize()
	level.room = Rect2i(0, 0, DUNGEON_SIZE.x, DUNGEON_SIZE.y)
	createSubSection(level)


func createSubSection(dungeon: Dungeon):
	var direction = randi_range(0,1)
	var randomOffset = randf_range(VARIATION.x, VARIATION.y)

	### VERTICAL SPLICING ###
	if direction:
		var offset = ceili(dungeon.room.size.x * randomOffset)
		### LEFT SIDE ###
		if offset > MIN_ROOM_SIZE:
			dungeon.leftSection = Dungeon.new()
			dungeon.leftSection.room = Rect2i(
				dungeon.room.position.x,
				dungeon.room.position.y,
				offset,
				dungeon.room.size.y
			)
			createSubSection(dungeon.leftSection)
		### RIGHT SIDE ###
		if (dungeon.room.size.x - offset) > MIN_ROOM_SIZE:
			dungeon.rightSection = Dungeon.new()
			dungeon.rightSection.room = Rect2i(
				dungeon.room.position.x + offset,
				dungeon.room.position.y,
				dungeon.room.size.x - offset,
				dungeon.room.size.y
			)
			createSubSection(dungeon.rightSection)
	### HORIZONTAL SPLICING ###
	else:
		var offset = ceili(dungeon.room.size.y * randomOffset)
		### UPPER SIDE ###
		if offset > MIN_ROOM_SIZE:
			dungeon.leftSection = Dungeon.new()
			dungeon.leftSection.room = Rect2i(
				dungeon.room.position.x,
				dungeon.room.position.y,
				dungeon.room.size.x,
				offset
			)
			createSubSection(dungeon.leftSection)
		### LOWER SIDE ###
		if (dungeon.room.size.y - offset) > MIN_ROOM_SIZE:
			dungeon.rightSection = Dungeon.new()
			dungeon.rightSection.room = Rect2i(
				dungeon.room.position.x,
				dungeon.room.position.y + offset,
				dungeon.room.size.x,
				dungeon.room.size.y - offset
			)
			createSubSection(dungeon.rightSection)


func _draw():
	drawDungeon(level)
	#pass

func drawDungeon(dungeon: Dungeon):
	draw_rect(dungeon.room, Color(1,1,1), false, 1)
	if dungeon.leftSection and dungeon.rightSection:
		draw_rect(dungeon.door, Color(0,1,0))
	if dungeon.leftSection:
		drawDungeon(dungeon.leftSection)
	if dungeon.rightSection:
		drawDungeon(dungeon.rightSection)
