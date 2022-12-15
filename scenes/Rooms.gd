extends Node2D

var room_scene: PackedScene = preload("res://scenes/Room.tscn")
var door_scene: PackedScene = preload("res://scenes/Door.tscn")

export(int) var num_levels: int = 1

onready var player: KinematicBody2D = get_parent().get_node("Player")

var room_size: Vector2 = Vector2(16, 10)
var cell_size: int = 16

func spawn_room() -> void:
	var room = room_scene.instance()
	var main_tilemap = room.get_node("MainTilemap")
	var bottom_tilemap = room.get_node("BottomTilemap")
	var furniture_tilemap = room.get_node("FurnitureTilemap")
	
	# Spawn floor and walls
	for x in range(0, room_size.x):
		for y in range(0, room_size.y):
			if y == 0:
				main_tilemap.set_cell(x, y, 6, false, false, false, Vector2(-1, 0))
			else:
				main_tilemap.set_cell(x, y, 7, false, false, false, Vector2(1, 0))
	for x in range(0, room_size.x):	# Top wall
		main_tilemap.set_cell(x, -1, 6, false, false, false, Vector2(0,2))
	for y in range(0, room_size.y):	# Left wall
		main_tilemap.set_cell(-1, y, 6, false, false, false, Vector2(1,4))
	for y in range(0, room_size.y):	# Right wall
		main_tilemap.set_cell(room_size.x, y, 6, false, false, false, Vector2(2,4))
	for x in range(0, room_size.x):	# Bottom wall
		bottom_tilemap.set_cell(x, room_size.y-1, 6, false, false, false, Vector2(0,2))
	# Corners
	main_tilemap.set_cell(-1, -1, 6, false, false, false, Vector2(-1,4))	# Top left
	main_tilemap.set_cell(room_size.x, -1, 6, false, false, false, Vector2(0,4)) # Top right
	bottom_tilemap.set_cell(-1, room_size.y-1, 6, false, false, false, Vector2(0,1))	# Bottom left
	bottom_tilemap.set_cell(room_size.x, room_size.y-1, 6, false, false, false, Vector2(1,1)) # Bottom right
	
	# Spawn Doors
	var door_x = int(room_size.x/4) + randi() % int(room_size.x/2)
	var door_y = 0
	var door = door_scene.instance()
	door.position = Vector2(door_x, door_y) * cell_size
	
	room.get_node("Doors").add_child(door)
	add_child(room)
	
