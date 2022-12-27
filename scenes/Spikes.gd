extends Hitbox

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("pierce")


func _collide(body: KinematicBody2D) -> void:
	if not body.flying:
		body.take_damage(damage, knockback_direction.normalized(), knockback_force)
