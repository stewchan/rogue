class_name Character, "res://assets/heroes/knight/knight_idle_anim_f0.png"
extends KinematicBody2D


const FRICTION : float = 20.0

export(int) var acceleration : int = 40
export(int) var max_speed : int = 100
export(int) var hp: int = 2 setget set_hp
export(bool) var flying: bool = false

signal hp_changed(new_hp)

onready var state_machine: Node = $FiniteStateMachine
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var move_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var immune: bool = false


func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)


func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * acceleration
	velocity = velocity.limit_length(max_speed)


func take_damage(damage: int, dir: Vector2, force: int) -> void:
	if(immune):
		return
	immune = true
	
	self.hp -= damage
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += dir * force * 2
	
	yield(get_tree().create_timer(0.5), "timeout")
	immune = false


func set_hp(new_hp: int) -> void:
	hp = new_hp
	emit_signal("hp_changed", hp)
