extends Enemy

onready var hitbox: Area2D = $Hitbox


func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()


func chase() -> void:
	if weakref(player).get_ref():
		if not nav_target:
			nav_target = player.position
		nav_agent.set_target_location(nav_target)
		animated_sprite.flip_h = move_direction.x < 0
