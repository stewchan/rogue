extends Node2D


onready var dungeon = $Dungeon


func _ready() -> void:
	new_game()


func new_game() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	SavedData.seed_val = rng.get_seed()
	SavedData.current_floor = 0
	var num_floors = 3
	dungeon.build_dungeon(3)
