class_name Hitbox
extends Area2D


export(int) var damage :int = 1
export(int) var knockback_force :int = 300

var knockback_direction: Vector2 = Vector2.ZERO

onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _init() -> void:
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")


func _ready() -> void:
	assert(collision_shape != null, "Hitbox must have a CollisionShape2D as its first child.")


func _on_body_entered(body: PhysicsBody2D) -> void:
	body.take_damage(damage, knockback_direction, knockback_force)
