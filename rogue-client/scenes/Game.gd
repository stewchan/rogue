extends Node2D


onready var dungeon = $Dungeon
onready var player = $Player
onready var hud = $HUD


func _ready() -> void:
	new_game()
	player.connect("hp_changed", hud, "_on_Player_hp_changed")


func new_game() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	GameData.seed_val = rng.get_seed()
	GameData.data.current_floor = 0
	var num_floors = 3
	dungeon.build_dungeon(num_floors)
