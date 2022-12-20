extends FSM


func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	

func _ready() -> void:
	set_state(states.move)
	

func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()


func _get_transition() -> int:
	var dist = parent.distance_to_player
	var max_dist = parent.MAX_DISTANCE_TO_PLAYER
	var min_dist = parent.MIN_DISTANCE_TO_PLAYER
	match state:
		states.idle:
			if dist > max_dist or dist < min_dist:
				return states.move
		states.move:
			if dist < max_dist and dist > min_dist:
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.move
	return -1


func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
