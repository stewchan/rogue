extends Node

var seed_val :int = 0

var data = {
	"hp": 4,
	"current_floor": 1,
	"name": "Player",
	"position": null,
}


var hp: int = 4 setget set_hp, get_hp
var current_floor: int = 1 setget set_current_floor, get_current_floor
var player_name: String setget set_player_name, get_player_name
var position: Vector2 = Vector2.ZERO setget set_position, get_position


func set_hp(value: int) -> void:
	data.hp = value
	Network.req_update(data)
func get_hp() -> int:
	return data.hp
	

func set_current_floor(value: int) -> void:
	data.current_floor = value
	Network.req_update(data)
func get_current_floor() -> int:
	return data.current_floor


func set_player_name(value: String) -> void:
	data.name = value
	Network.req_update(data)
func get_player_name() -> String:
	return data.name


func set_position(value: Vector2) -> void:
	data.position = value
	Network.req_update(data)
func get_position() -> Vector2:
	return data.position


#var weapons: Array = []
#var equipped_weapon_index: int = 0
