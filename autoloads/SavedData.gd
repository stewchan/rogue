extends Node

var seed_val :int = 0

var hp: int = 4
var current_floor: int = 1 setget set_current_floor

var max_floor_reached: int = 1

var weapons: Array = []
var equipped_weapon_index: int = 0


func set_current_floor(cur_floor: int) -> void:
	if cur_floor > max_floor_reached:
		max_floor_reached = cur_floor
	current_floor = cur_floor
