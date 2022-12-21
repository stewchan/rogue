extends Node2D

var room_scene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")

export(int) var num_levels: int = 1

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")

var cell_size: int = 16
var num_rooms: int = 3


func spawn_rooms() -> void:
	randomize()
	var prev_room: Node2D
	var room: Node2D
	
	for i in range(0, num_rooms):
		var size = Vector2(floor(randi()%6 + 8), floor(randi()%6 + 8))
		if i == 0:
			room = generate_room(size, true, false) # starting room
			spawn_player(room)
		elif i == num_rooms - 1:
			room = 	generate_room(size, false, true) # end room
			# warning-ignore:return_value_discarded
			room.get_node("Stairs").connect("body_entered", self, "on_body_entered_stairs_down")
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

	
func generate_room(room_size: Vector2, start_room: bool = false, end_room: bool = false) -> Node2D:
	var room = room_scene.instance()
	add_child(room)
	room.build(room_size, start_room, end_room)
	var num_enemies = 1#1 + randi() % 3
	room.add_enemies(num_enemies)
	return room
	

func spawn_player(room: Node2D) -> void:
	var entrance = room.get_node("Entrance").get_child(0)
	player.position = entrance.position
	var room_size = room.get_node("MainTilemap").get_used_rect().size - Vector2(2,1)
	var x = 1 + randi() % int(room_size.x - 1)
	var y = room_size.y - 2
	player.position = Vector2(x, y) * cell_size


func on_body_entered_stairs_down(_body: KinematicBody2D) -> void:
	print("stairs down")
