extends Enemy

const MAX_DISTANCE_TO_PLAYER: int = 90
const MIN_DISTANCE_TO_PLAYER: int = 40


var distance_to_player: float


func _physics_process(_delta: float) -> void:
	distance_to_player = (global_position - player.global_position).length()
	if nav_agent.is_target_reachable():
		move_direction = position.direction_to(nav_agent.get_next_location())
	

func chase() -> void:
	if weakref(player).get_ref():
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			nav_target = player.position
			nav_agent.set_target_location(nav_target)
		if distance_to_player < MIN_DISTANCE_TO_PLAYER:
			nav_target = _get_retreat_target()
			nav_agent.set_target_location(nav_target)
		animated_sprite.flip_h = move_direction.x < 0


func _get_retreat_target() -> Vector2:
	var dir: Vector2 = (global_position - player.global_position).normalized()
	var target: Vector2 = (global_position + dir * 100)
	return target
