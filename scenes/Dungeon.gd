extends Node2D

var RoomScene: PackedScene = preload("res://scenes/Room.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")
var SceneTransition: PackedScene = preload("res://autoloads/SceneTransition.tscn")

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")
onready var cur_floor = $Floor

var cell_size: int = 16

var max_floors: int = 3


func build_dungeon() -> void:
	descend()


# Build a dungeon with the given number of floors
func build_floor(floor_num: int) -> void:
	cur_floor.build_floor(SavedData.current_floor)
	_spawn_player()


func ascend() -> void:
	if SavedData.current_floor >= 2:
		var transition = SceneTransition.instance()
		add_child(transition)
		SavedData.current_floor -= 1
		build_floor(SavedData.current_floor)


func descend() -> void:
	if SavedData.current_floor < max_floors:
		var transition = SceneTransition.instance()
		add_child(transition)
		SavedData.current_floor += 1
		build_floor(SavedData.current_floor)
	

func _spawn_player() -> void:
	var spawn_pos = cur_floor.get_node("Room0").get_node("PlayerSpawnPoint").position
	player.position = spawn_pos


func on_body_entered_stairs_down(_body: KinematicBody2D) -> void:
	print("Going down stairs...")
#	SceneTransition.start_transition_to("res://scenes/Game.tscn")
#	SavedData.current_floor += 1
