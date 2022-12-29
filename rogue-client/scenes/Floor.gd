extends Node2D


var RoomScene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")

var cell_size: int = 16

var rooms: Array = []


func clear() -> void:
	for n in get_children():
		remove_child(n)
		n.queue_free()


func build_floor(floor_num: int) -> void:
	seed(GameData.seed_val % floor_num * 13)

	# TODO: change number of rooms based on floor_num
	var num_rooms = 2
	var room: Node2D

	for i in range(0, num_rooms):
		var size = Vector2(floor(randi()%6 + 8), floor(randi()%6 + 8))
		if i == 0:
			room = generate_room(size, true, false) # starting room
		elif i == num_rooms - 1:
			room = 	generate_room(size, false, true) # end room
			var num_enemies = 1#1 + randi() % 3
			room.add_enemies(num_enemies)
		else:
			room = 	generate_room(size) # regular room
			var num_enemies = 1#1 + randi() % 3
			room.add_enemies(num_enemies)
		room.name = "Room" + str(i)
		room.z_index = -i
		room.spawn_enemies()
		rooms.push_back(room)
		if i != 0:
			var door_pos = rooms[i-1].get_node("Doors").get_child(0).global_position
			var entrance_pos = room.get_node("Entrance").get_child(0).global_position
			room.position.x += door_pos.x - entrance_pos.x
			room.position.y =  rooms[i-1].position.y - size.y * cell_size

			# warning-ignore:return_value_discarded
			rooms[i-1].get_node("Doors").get_child(0).connect("opened", room, "spawn_enemies")



func set_player_spawn(player: KinematicBody2D, descending: bool):
	var room: Node2D
	if descending:
		room = get_children().pop_front()
	else:
		room = get_children().pop_back()
	room.set_player_spawn_point(descending)
	player.global_position = room.get_node("PlayerSpawnPoint").global_position


func generate_room(room_size: Vector2, start_room: bool = false, end_room: bool = false) -> Node2D:
	var room = RoomScene.instance()
	add_child(room)
	room.build(room_size, start_room, end_room)
	return room


