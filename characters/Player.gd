extends Character


func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - get_global_position()).normalized()

	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and !animated_sprite.flip_h:
		animated_sprite.flip_h = true


func get_input() -> void:
	move_direction = Vector2.ZERO
	if Input.is_action_pressed("down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("right"):
		move_direction += Vector2.RIGHT
