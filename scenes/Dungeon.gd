extends Node2D

var StairsScene: PackedScene = preload("res://scenes/Stairs.tscn")
var FloorScene: PackedScene = preload("res://scenes/Floor.tscn")

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")

var cell_size: int = 16

var max_floors: int = 3

var current_floor: Node2D
var previous_floor: Node2D


# Build a dungeon with the given number of floors
func build_dungeon(num_floors: int) -> void:
	max_floors = num_floors
	descend()


func ascend() -> void:
	if SavedData.current_floor >= 2:
		SavedData.current_floor -= 1
		rebuild_floor(SavedData.current_floor, true)
		var last_room = current_floor.get_children().pop_back()
		last_room.set_player_spawn_point(false)


func descend() -> void:
	if SavedData.current_floor < max_floors:
		SavedData.current_floor += 1
		rebuild_floor(SavedData.current_floor)
		var first_room = current_floor.get_children().pop_front()
		first_room.set_player_spawn_point(true)


func rebuild_floor(floor_num: int, descending: bool = true) -> void:
	previous_floor = current_floor
	current_floor = FloorScene.instance()
	current_floor.name = "Floor" + str(floor_num)
	add_child(current_floor)
	current_floor.build_floor(floor_num)
	_connect_stairs()
	_spawn_player(player, descending)
	
	if floor_num == max_floors:
		pass
#		current_floor.get_children().pop_back()
	if previous_floor:
		previous_floor.queue_free()
	

func _connect_stairs() -> void:
	for room in current_floor.get_children():
		for stairs in room.get_node("Stairs").get_children():
			if stairs:
				if stairs.name == "StairsDown":
					stairs.connect("stairs_entered", self, "descend")
				if stairs.name == "StairsUp":
					stairs.connect("stairs_entered", self, "ascend")


func _spawn_player(player, descending: bool = true) -> void:
	current_floor.set_player_spawn(player, descending)



