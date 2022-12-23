extends Enemy


func duplicate_slime() -> void:
	if scale > Vector2(1,1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(rand_range(0, 2*PI))
		_spawn_slime(impulse_direction)
		_spawn_slime(-impulse_direction)


func _spawn_slime(direction: Vector2) -> void:
	var slime: KinematicBody2D = load("res://characters/enemy/slime_boss/SlimeBoss.tscn").instance()
	slime.position = position
	slime.scale = scale/2
	slime.hp = max_hp/2.0
	slime.max_hp = max_hp/2.0
	get_parent().add_child(slime)
	slime.velocity += direction * 150
