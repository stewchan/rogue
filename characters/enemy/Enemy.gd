class_name Enemy, "res://assets/enemies/goblin/goblin_idle_anim_f0.png"
extends Character


onready var navigation: Navigation2D = get_tree().current_scene.get_node("Navigation2D")
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var path_timer : Timer = $PathTimer

var path: PoolVector2Array


func chase() -> void:
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		if distance_to_next_point < 1:
			path.remove(0)
			if not path:
				return
		move_direction = vector_to_next_point
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true


func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		path = navigation.get_simple_path(global_position, player.global_position)
	else:
		path_timer.stop()
		path = []
		move_direction = Vector2.ZERO
	

