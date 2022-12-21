extends Hitbox

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("pierce")


func _collide(body: KinematicBody2D) -> void:
	if not body.flying:
		knockback_direction.normalized()
		body.take_damage(damage, knockback_direction, knockback_force)
