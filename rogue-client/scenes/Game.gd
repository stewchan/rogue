extends Node2D

onready var dungeon = $Dungeon
onready var player = $Player
onready var hud = $HUD
onready var network = $Network


func _ready() -> void:
	network.connect_to_server()
	new_game()
	# Todo connect all signals
	player.connect("hp_changed", hud, "_on_Player_hp_changed")


func new_game() -> void:
	# Generate new game seed
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	GameData.seed_val = rng.get_seed()
	GameData.data.current_floor = 0
	
	var num_floors = 3
	dungeon.build_dungeon(num_floors)
