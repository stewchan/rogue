class_name Player
extends Character


onready var sword: Node2D = $Sword
onready var sword_hitbox: Area2D = $Sword/Node2D/Sprite/Hitbox
onready var sword_animation_player = $Sword/SwordAnimationPlayer


func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - get_global_position()).normalized()
	animated_sprite.flip_h = mouse_direction.x < 0

	sword.rotation = mouse_direction.angle()
	sword_hitbox.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
	

func get_input() -> void:
	move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("ui_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_attack") and not sword_animation_player.is_playing():
		sword_animation_player.play("attack")


