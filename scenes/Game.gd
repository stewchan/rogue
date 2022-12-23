extends Node2D


onready var dungeon = $Dungeon

func _init() -> void:
	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()

	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)


func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	SavedData.seed_val = rng.get_seed()
	var num_floors = 3
	dungeon.build_dungeon(num_floors)
	dungeon.spawn_player()
