extends Node2D

const ENEMY_SCENES: Dictionary = {
	"FlyingCreature": preload("res://characters/enemy/flying_creature/FlyingCreature.tscn"),
	"Goblin": preload("res://characters/enemy/goblin/Goblin.tscn"),
	"SlimeBoss": preload("res://characters/enemy/slime_boss/SlimeBoss.tscn")
}
var ExplosionSpawn: PackedScene = preload("res://characters/enemy/SpawnExplosion.tscn")
var DoorScene: PackedScene = preload("res://scenes/Door.tscn")
var StairsScene: PackedScene = preload("res://scenes/Stairs.tscn")
var SpikeScene: PackedScene = preload("res://scenes/Spikes.tscn")

onready var entrance: Node2D = $Entrance
onready var doors: Node2D = $Doors
onready var enemy_positions: Node2D = $EnemyPositions
onready var enemies: Node2D = $Enemies
onready var door_trigger: Area2D = $DoorTrigger
onready var main_tilemap: TileMap = $MainTilemap
onready var bottom_tilemap: TileMap = $BottomTilemap
onready var furniture_tilemap: TileMap = $FurnitureTilemap
onready var navpoly_instance: NavigationPolygonInstance = $NavigationPolygonInstance
onready var traps: Node2D = $Traps
onready var player_spawn_point = $PlayerSpawnPoint

var room_size: Vector2
var cell_size: int = 16


func _open_doors() -> void:
	for door in doors.get_children():
		door.open()
	
	
#func _close_entrance() -> void:
#	for entry_position in entrance.get_children():
#		pass
#		var pos = tilemap.world_to_map(entry_position.position)
#		var wall = Vector2(1, 2)
#		var stone = Vector2(0, 0)
#		tilemap.set_cellv(pos, 6, false, false, false, wall)
#		tilemap.set_cellv(pos + Vector2.DOWN, 6, false, false, false, stone)


func add_enemies(num_enemies: int) -> void:
	for _i in range(0, num_enemies):
		var enemy = Position2D.new()
		var x = (1 + randi() % int(room_size.x - 1)) * cell_size
		var y = (1 + randi() % int(room_size.y/2)) * cell_size
		enemy.position = Vector2(x, y)
		enemy_positions.add_child(enemy)
		
		
func spawn_enemies() -> void:
	for enemy_pos in enemy_positions.get_children():
		var enemy: KinematicBody2D = ENEMY_SCENES.Goblin.instance()
		# warning-ignore:return_value_discarded
		enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.position = enemy_pos.position
		enemies.call_deferred("add_child", enemy)
		var spawn_explosion: AnimatedSprite = ExplosionSpawn.instance()
		spawn_explosion.position = enemy_pos.position
		call_deferred("add_child", spawn_explosion)
		enemy_pos.queue_free()


func _on_enemy_killed() -> void:
	if enemies.get_child_count() == 0:
		_open_doors()


func _on_DoorTrigger_body_entered(body: KinematicBody2D) -> void:
	if body == Player:
		_open_doors()
		door_trigger.queue_free()


# build a room of a given size
func build(size: Vector2, start_room: bool = false, end_room: bool = false) -> void:
	room_size = size
	_create_floors_and_walls()
	_create_entrance(start_room)
	_create_door(end_room)
	_create_stairs(end_room)
	_add_spikes(Vector2(5,5))


func _create_floors_and_walls() -> void:
	var vects: PoolVector2Array = []
	for x in range(0, room_size.x):
		for y in range(0, int(room_size.y)):
			vects.push_back(Vector2(x, y))
	for vect in vects:
		if vect.y == 0:
			main_tilemap.set_cellv(vect, 6, false, false, false, Vector2(0, 0))
		else:
			main_tilemap.set_cellv(vect, 10, false, false, false, Vector2(1, 0))
	# Create surrounding walls
	for x in range(0, int(room_size.x)):	# Top wall
		main_tilemap.set_cell(x, -1, 6, false, false, false, Vector2(1,2))
	for y in range(0, int(room_size.y)):	# Left wall
		main_tilemap.set_cell(-1, y, 6, false, false, false, Vector2(2,4))
	for y in range(0, int(room_size.y)):	# Right wall
		main_tilemap.set_cell(int(room_size.x), y, 6, false, false, false, Vector2(3,4))
	for x in range(0, room_size.x):	# Bottom wall
		bottom_tilemap.set_cell(x, int(room_size.y)-1, 6, false, false, false, Vector2(1,2))
	# Create Corners
	main_tilemap.set_cell(-1, -1, 6, false, false, false, Vector2(0,4))	# Top left
	main_tilemap.set_cell(int(room_size.x), -1, 6, false, false, false, Vector2(1,4)) # Top right
	bottom_tilemap.set_cell(-1, int(room_size.y)-1, 6, false, false, false, Vector2(1,1))	# Bottom left
	bottom_tilemap.set_cell(int(room_size.x), int(room_size.y)-1, 6, false, false, false, Vector2(2,1)) # Bottom right
	# Create navpoly for the entire room
#	var rect = main_tilemap.get_used_rect()
#	_create_navpoly_instance(rect)


# The opening or entrance at the bottom of the room
func _create_entrance(start_room: bool) -> void:
	var entry_pos = Position2D.new()
	var x = 1 +  randi() % int(int(room_size.x) - 2)
	var y = room_size.y
	entry_pos.name = "Position2D"
	entrance.add_child(entry_pos)
	entry_pos.position = Vector2(x, y) * cell_size
	
	# If this is a starting room create a spawn point
	if start_room:
		player_spawn_point.position = entry_pos.position + Vector2(0, -2) * cell_size

	# Remove wall
	if not start_room:
		bottom_tilemap.set_cell(x, int(room_size.y)-1, -1)
		bottom_tilemap.set_cell(x-1, int(room_size.y)-1, -1)
	

func _create_door(end_room:bool = false) -> void:
	if end_room:
		return
	var	x = int(room_size.x/4) + randi() % int(room_size.x/2)
	var door = DoorScene.instance()
	door.position = Vector2(x, 0) * cell_size
	main_tilemap.set_cell(x, -1, -1) # Remove border walls
	main_tilemap.set_cell(x-1, -1, -1)
	main_tilemap.set_cell(x, 0, 10, false, false, false, Vector2(1, 0)) # Floor under door
	main_tilemap.set_cell(x-1, 0, 10, false, false, false, Vector2(1, 0))
	doors.add_child(door)
	door_trigger.position = door.position + Vector2(0, cell_size * 1.5)
	# Create a navpoly for door
#	var rect = Rect2(door.position, Vector2(cell_size, cell_size))
#	_create_navpoly_instance(rect)


func _create_stairs(end_room: bool = false) -> void:
	if not end_room:
		return
	var x = 1 + randi() % int(room_size.x - 2)
	var stairs = StairsScene.instance()
	stairs.position = Vector2(x, 2) * cell_size
	add_child(stairs)
	move_child(stairs, 4)


# Call after room creation to fill the room with a nav polygon instance
func _create_navpoly_instance(rect: Rect2) -> void:
	var polygon = NavigationPolygon.new()
	var outline = PoolVector2Array([Vector2(0,0), Vector2(rect.end.x, 0), rect.end, Vector2(0, rect.end.y)])
	polygon.add_outline(outline)
	polygon.make_polygons_from_outlines()
	navpoly_instance.navpoly = polygon


# Add spike traps relative to the tilemap position
func _add_spikes(pos: Vector2) -> void:
	pos -= Vector2(0.5, 0.5)
	for x in range(0, 2):
		for y in range(0, 2):
			var vect = Vector2(x, y)
			var spikes = SpikeScene.instance()
			spikes.position = (pos + vect) * cell_size
			traps.add_child(spikes)
	

#func spawn_player(player: Player) -> void:
#	var entrance = entrance.get_child(0)
#	add_child(player)
#	player.position = entrance.position
#


func _add_furniture(_pos: Vector2, _furniture: Vector2) -> void:
	pass


