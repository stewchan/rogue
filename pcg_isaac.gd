extends Node

##
## Everything beyond here is experimental
## procedural generation
##

func _process(_delta: float) -> void:
	if started:
		update()

var floorplan: Array = []
var floorplan_count: int = 0
var min_rooms: int = 15
var max_rooms: int = 25
var end_rooms: Array = []
var cell_queue: Array = []
var images: Array = []
var bossl: int
var started: bool = false
var placed_special: bool = false


func add_img(i, name):
	var x = i % 10;
	var y = (i - x) / 10;
#    var img = scene.add.image(W/2 + cellw * (x - 5), H/2 + cellh * (y - 4), name);
#    images.push(img);
#    return img;


func pop_random_endroom() -> int:
	var index = floor(randi() % end_rooms.size());
	var i = end_rooms[index];
	end_rooms.remove(index);
	return i;


func pick_secret_room() -> int:
	for e in range(0,900):
		var x = randi() % 9 + 1
		var y = randi() % 8 + 2
		var i = y*10 + x
		if(floorplan[i]):
			continue
		if (bossl == i-1 || bossl == i+1 || bossl == i+10 || bossl == i-10):
			continue
		if ncount(i) >= 3:
			return i;
		if e > 300 and ncount(i) >= 2:
			return i;
		if e > 600 and ncount(i) >= 1:
			return i;
	return 0


func update() -> void:
	if not started:
		return
	
	if cell_queue.size() > 0:
		var i = cell_queue.pop_front()
		var x = i % 10
		var created = false;
		if x > 1: created = created or visit(i - 1);
		if x < 9: created = created or visit(i + 1);
		if i > 20: created = created or visit(i - 10);
		if i < 70: created = created or visit(i + 10);
		if not created:
			end_rooms.push_back(i)
	else:
		
		var line = ""
		for i in range(0,floorplan.size()):
			if i % 10 == 0:
				line += "\n"
			line += str(floorplan[i])
		print(line)
#	elif not placed_special:
#		if floorplan_count < min_rooms:
#			update()
#			return
#
#		placed_special = true
#		bossl = end_rooms.pop_front()
#		var cell_image = add_img(bossl, 'boss')
#		cell_image.x += 1
#
#		var rewardl = pop_random_endroom()
#		cell_image = add_img(rewardl, 'reward')
#
#		var coinl = pop_random_endroom()
#		add_img(coinl, 'coin')
#
#		var secretl = pick_secret_room();
#		add_img(secretl, 'cell');
#		add_img(secretl, 'secret');
#
#		if !rewardl or !coinl or !secretl:
#			update()
#			return


func start() -> void:
	started = true
	placed_special = false
	#    images.forEach(image => {
	#        image.destroy();
	#    });
	images = []
	floorplan = []
	for i in range(0, 101):
		floorplan.append(0)
	floorplan_count = 0
	cell_queue = []
	end_rooms = []
	visit(45)


func ncount(i) -> int:
	return floorplan[i-10] + floorplan[i-1] + floorplan[i+1] + floorplan[i+10]


func visit(i) -> bool:
	if floorplan[i]:
		return false

	var num_neighbours = ncount(i)
	if num_neighbours > 1:
		return false
	if floorplan_count >= max_rooms:
		return false
	if randf() < 0.5 and i != 45:
		return false

	cell_queue.push_back(i)
	floorplan[i] = 1
	floorplan_count += 1
	# img(scene, i, 'cell')
	return true
