extends Node2D

var room_scene: PackedScene = preload("res://scenes/Room.tscn")
var door_scene: PackedScene = preload("res://scenes/Door.tscn")

export(int) var num_levels: int = 1

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")

var cell_size: int = 16
var num_rooms: int = 5

func spawn_rooms() -> void:
	var prev_room: Node2D
	var room: Node2D
	for i in range(0, num_rooms):
		if i == 0:
			room = generate_room(Vector2(10,10), true)
		elif i == num_rooms - 1:
			room = 	generate_room(Vector2(10,10), false, true)
		else:
			room = 	generate_room(Vector2(10,10))
		room.name = "Room" + str(i)
		if prev_room:
			var door_x = prev_room.get_node("Doors").get_child(0).position.x
			var entrance_x = room.get_node("Entrance").get_child(0).position.x
			print(str(door_x) + " : " + str(entrance_x))
			room.global_position.x += door_x - entrance_x
			room.global_position.y -=  12 * cell_size * i
		prev_room = room
		add_child(room)

	
func generate_room(room_size: Vector2, is_start_room: bool = false, is_end_room: bool = false) -> Node2D:
	camera.position = room_size * cell_size * 0.5
	var room = room_scene.instance()
	var main_tilemap = room.get_node("MainTilemap")
	var bottom_tilemap = room.get_node("BottomTilemap")
	var furniture_tilemap = room.get_node("FurnitureTilemap")
	
	# Spawn floor and walls
	for x in range(0, room_size.x):
		for y in range(0, room_size.y):
			if y == 0:
				main_tilemap.set_cell(x, y, 6, false, false, false, Vector2(0, 0))
			else:
				main_tilemap.set_cell(x, y, 7, false, false, false, Vector2(1, 0))
	for x in range(0, room_size.x):	# Top wall
		main_tilemap.set_cell(x, -1, 6, false, false, false, Vector2(1,2))
	for y in range(0, room_size.y):	# Left wall
		main_tilemap.set_cell(-1, y, 6, false, false, false, Vector2(2,4))
	for y in range(0, room_size.y):	# Right wall
		main_tilemap.set_cell(room_size.x, y, 6, false, false, false, Vector2(3,4))
	for x in range(0, room_size.x):	# Bottom wall
		bottom_tilemap.set_cell(x, room_size.y-1, 6, false, false, false, Vector2(1,2))
		
	# Corners
	main_tilemap.set_cell(-1, -1, 6, false, false, false, Vector2(0,4))	# Top left
	main_tilemap.set_cell(room_size.x, -1, 6, false, false, false, Vector2(1,4)) # Top right
	bottom_tilemap.set_cell(-1, room_size.y-1, 6, false, false, false, Vector2(1,1))	# Bottom left
	bottom_tilemap.set_cell(room_size.x, room_size.y-1, 6, false, false, false, Vector2(2,1)) # Bottom right
	
	# Generate door
	var	door_x = int(room_size.x/4) + randi() % int(room_size.x/2)
	var door = door_scene.instance()
	door.position = Vector2(door_x, 0) * cell_size
	main_tilemap.set_cell(door_x, 0, -1)
	main_tilemap.set_cell(door_x-1, 0, -1)
	main_tilemap.set_cell(door_x, -1, -1)
	main_tilemap.set_cell(door_x-1, -1, -1)
	room.get_node("Doors").add_child(door)
	# Door trigger
	room.get_node("DoorTrigger").position = door.position + Vector2(0, cell_size * 1.5)
	
	
	# Generate entrance position
	var entrance = Position2D.new()
	var entrance_x = 1 +  randi() % int(room_size.x - 2)
	var entrance_y = room_size.y
	entrance.position = Vector2(entrance_x, entrance_y) * cell_size
	entrance.name = "Position2D"
	# Remove wall
	if not is_start_room:
		bottom_tilemap.set_cell(entrance_x, room_size.y-1, -1)
		bottom_tilemap.set_cell(entrance_x-1, room_size.y-1, -1)
	room.get_node("Entrance").add_child(entrance)
	

	# Generate enemies
	var num_enemies = 1 + randi() % 3
	for i in range(0, num_enemies):
		var enemy_position = Position2D.new()
		var x = (1 + randi() % int(room_size.x - 1)) * cell_size
		var y = (1 + randi() % int(room_size.y/2)) * cell_size
		enemy_position.position = Vector2(x, y)
		room.get_node("EnemyPositions").add_child(enemy_position)


	# Spawn player starting position if starting room
	if is_start_room:
		var start_x = 1 + randi() % int(room_size.x - 1)
		var start_y = room_size.y - 2
		var player_start = Position2D.new()
		player_start.position = Vector2(start_x, start_y) * cell_size
		room.get_node("PlayerStart").add_child(player_start)
		
		player.position = player_start.position
	
	return room




