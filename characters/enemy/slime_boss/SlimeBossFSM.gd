extends FSM

onready var jump_timer = $JumpTimer

var can_jump: bool = false


func _ready() -> void:
	set_state(states.idle)
	jump_timer.start()


func _init() -> void:
	_add_state("idle")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")


func _state_logic(_delta: float) -> void:
	if state == states.jump:
		parent.chase()
		parent.move()


func _get_transition() -> int:
	match state:
		states.idle:
			if can_jump:
				return states.jump
		states.jump:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle			
	return -1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			# TODO: stop navigation
			animation_player.play("jump")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")


func _exit_state(_state_exited: int) -> void:
	if _state_exited == states.jump:
		can_jump = false
		jump_timer.start()
		#TODO: start navigation


func _on_JumpTimer_timeout() -> void:
	can_jump = true # Replace with function body.
