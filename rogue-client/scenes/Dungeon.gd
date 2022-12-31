extends Node2D

var StairsScene: PackedScene = preload("res://scenes/Stairs.tscn")
var FloorScene: PackedScene = preload("res://scenes/Floor.tscn")
var SceneTransition: PackedScene = preload("res://scenes/SceneTransition.tscn")

var cell_size: int = 16
var max_floors: int = 3
var current_floor: Node2D
var previous_floor: Node2D

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var camera: Camera2D = get_parent().get_node("Camera2D")
onready var players: Array = get_parent().get_node("Players").get_children()


# Build a dungeon with the given number of floors
func build_dungeon(num_floors: int) -> void:
	max_floors = num_floors
	descend()


func ascend() -> void:
	if GameData.current_floor <= 1:
		return
	add_child(SceneTransition.instance())
	yield(get_tree().create_timer(0.3), "timeout")
	GameData.data.current_floor -= 1
	rebuild_floor(GameData.current_floor)
	var last_room = current_floor.get_children().pop_back()
	last_room.set_player_spawn_point(false)
	_spawn_player(false)


func descend() -> void:
	if GameData.current_floor == max_floors:
		return
	add_child(SceneTransition.instance())
	yield(get_tree().create_timer(0.3), "timeout")
	GameData.current_floor += 1
	rebuild_floor(GameData.current_floor)
	var first_room = current_floor.get_children().pop_front()
	first_room.set_player_spawn_point(true)
	_spawn_player(true)


func rebuild_floor(floor_num: int) -> void:
	previous_floor = current_floor
	current_floor = FloorScene.instance()
	current_floor.name = "Floor" + str(floor_num)
	add_child(current_floor)
	current_floor.build_floor(floor_num)
	_connect_stairs()

	# Remove stairs at top and bottom of dungeon
	if floor_num == 1:
		var room = current_floor.get_children().pop_front()
		room.get_node("Stairs/StairsUp").queue_free()
	if floor_num == max_floors:
		var room = current_floor.get_children().pop_back()
		room.get_node("Stairs/StairsDown").queue_free()

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


func _spawn_player(descending: bool = true) -> void:
	current_floor.set_player_spawn(player, descending)
	for p in players:
		GameData.position = p.global_position



