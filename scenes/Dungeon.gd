extends Node2D

var RoomScene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")
onready var cur_floor = $Floor

var cell_size: int = 16

var floor_num: int = 0

# Build a dungeon with the given number of floors
func build_dungeon(num_floors: int) -> void:
	if floor_num == 0:
		floor_num += 1
		cur_floor.build_floor(floor_num)
	

func spawn_player() -> void:
	var spawn_pos = cur_floor.get_node("Room0").get_node("PlayerSpawnPoint").position
	player.position = spawn_pos
	print(spawn_pos)
	print(player.position)
	


func on_body_entered_stairs_down(_body: KinematicBody2D) -> void:
	print("Going down stairs...")
#	SceneTransition.start_transition_to("res://scenes/Game.tscn")
#	SavedData.current_floor += 1
