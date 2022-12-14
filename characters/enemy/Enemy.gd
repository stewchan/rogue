class_name Enemy, "res://assets/enemies/goblin/goblin_idle_anim_f0.png"
extends Character


onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _physics_process(_delta: float) -> void:
	if nav_agent.is_target_reachable():
		move_direction = position.direction_to(nav_agent.get_next_location())
		nav_agent.set_velocity(velocity)


func chase() -> void:
	if weakref(player).get_ref():
		nav_agent.set_target_location(player.position)
		animated_sprite.flip_h = move_direction.x < 0

	

