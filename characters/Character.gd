class_name Character, "res://assets/heroes/knight/knight_idle_anim_f0.png"
extends KinematicBody2D


const FRICTION : float = 20.0

export(int) var acceleration : int = 40
export(int) var max_speed : int = 100

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var move_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)


func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * acceleration
	velocity = velocity.clamped(max_speed)
