extends Node2D

var RoomScene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")
var FloorScene: PackedScene = preload("res://scenes/Floor.tscn")

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")

var cell_size: int = 16

var floor_num: int = 0

# Build a dungeon with the given number of floors
func build_dungeon(num_floors: int) -> void:
	if floor_num == 0:
		floor_num += 1
		var flr = FloorScene.instance()
		flr.name = "Floor" + str(floor_num)
		add_child(flr)
		flr.build_floor(floor_num)
	

func on_body_entered_stairs_down(_body: KinematicBody2D) -> void:
	print("Going down stairs...")
#	SceneTransition.start_transition_to("res://scenes/Game.tscn")
#	SavedData.current_floor += 1
