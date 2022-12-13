extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://characters/enemy/SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FlyingCreature": preload("res://characters/enemy/FlyingCreature.tscn")
}

const DOOR_SCENE = preload("res://scenes/Door.tscn")

var num_enemies: int

onready var tilemap: TileMap = $Navigation2D/TileMap2
onready var entrance: Node2D = $Entrance
onready var door_container: Node2D = $Doors
onready var enemy_positions_container: Node2D = $EnemyPositions
onready var player_detector: Area2D = $PlayerDetector


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	create_doors()
	
	
# Create the exit doors
func create_doors() -> void:
	var position = door_container.get_node("Position2D").position
	door_container.get_node("Position2D").queue_free()
	var door = DOOR_SCENE.instance()
	door.position = position
	door_container.add_child(door)


func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
	
	
func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		var pos = tilemap.world_to_map(entry_position.position)
		var wall = Vector2(1, 2)
		var stone = Vector2(0, 0)
		tilemap.set_cellv(pos, 6, false, false, false, wall)
		tilemap.set_cellv(pos + Vector2.DOWN, 6, false, false, false, stone)
	

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D = ENEMY_SCENES.FlyingCreature.instance()
		# warning-ignore:return_value_discarded
		enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)
		

func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()


func _on_PlayerDetector_body_entered(_body: KinematicBody2D) -> void:
	_close_entrance()
	_spawn_enemies()
	player_detector.queue_free()
