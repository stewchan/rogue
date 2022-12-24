extends Node2D

var RoomScene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")

export(int) var num_levels: int = 1

var cell_size: int = 16


func clear() -> void:
	for n in get_children():
		remove_child(n)
		n.queue_free()


func build_floor(floor_num: int) -> void:
	seed(SavedData.seed_val % floor_num * 13)
	
	# TODO: change number of rooms based on floor_num
	var num_rooms = 2
	var prev_room: Node2D
	var room: Node2D
	
	for i in range(0, num_rooms):
		var size = Vector2(floor(randi()%6 + 8), floor(randi()%6 + 8))
		if i == 0:
			room = generate_room(size, true, false) # starting room
		elif i == num_rooms - 1:
			room = 	generate_room(size, false, true) # end room
			# warning-ignore:return_value_discarded
#			room.get_node("Stairs").connect("body_entered", get_parent(), "descend")
		else:
			room = 	generate_room(size) # regular room
		room.name = "Room" + str(i)
		room.z_index = -i
		room.spawn_enemies()
		if prev_room:
			var door_pos = prev_room.get_node("Doors").get_child(0).global_position
			var entrance_pos = room.get_node("Entrance").get_child(0).global_position
			room.position.x += door_pos.x - entrance_pos.x
			room.position.y =  prev_room.position.y - size.y * cell_size 
			
			# warning-ignore:return_value_discarded
			prev_room.get_node("Doors").get_child(0).connect("opened", room, "spawn_enemies")
		prev_room = room


func set_player_spawn(player: KinematicBody2D, descending: bool):
	var room: Node2D
	if descending:
		room = get_children().pop_front()
	else:
		room = get_children().pop_back()
	room.set_player_spawn_point(descending)
	player.position = room.get_node("PlayerSpawnPoint").position

	
func generate_room(room_size: Vector2, start_room: bool = false, end_room: bool = false) -> Node2D:
	var room = RoomScene.instance()
	add_child(room)
	room.build(room_size, start_room, end_room)
	var num_enemies = 1#1 + randi() % 3
	room.add_enemies(num_enemies)
	return room


