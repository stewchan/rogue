extends Node2D

var RoomScene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")
var StairsScene: PackedScene = preload("res://scenes/Stairs.tscn")
var SceneTransition: PackedScene = preload("res://autoloads/SceneTransition.tscn")

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")
onready var cur_floor = $Floor

var cell_size: int = 16

var max_floors: int = 3


# Build a dungeon with the given number of floors
func build_dungeon(num_floors: int) -> void:
	max_floors = num_floors
	descend()


func ascend() -> void:
	if SavedData.current_floor >= 2:
		SavedData.current_floor -= 1
		rebuild_floor(SavedData.current_floor)


func descend() -> void:
	print(SavedData.current_floor)
	if SavedData.current_floor < max_floors:
		SavedData.current_floor += 1
		rebuild_floor(SavedData.current_floor)


func rebuild_floor(floor_num: int) -> void:
	# Delete the current floor
	for n in cur_floor.get_children():
		cur_floor.remove_child(n)
		n.queue_free()
	cur_floor.build_floor(floor_num)
	if floor_num != max_floors:
		_spawn_stairs()
	_spawn_player()


func _spawn_stairs() -> void:
	var room = cur_floor.get_children().pop_back()
	var spawn_position = room.get_node("StairSpawnPoint").position
	var stairs_down = StairsScene.instance()
	room.add_child(stairs_down)
	stairs_down.position = spawn_position
	stairs_down.connect("descend", self, "descend")
	

func _spawn_player() -> void:
	var spawn_pos = cur_floor.get_node("Room0").get_node("PlayerSpawnPoint").position
	player.position = spawn_pos


