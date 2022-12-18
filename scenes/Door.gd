extends StaticBody2D

signal opened

onready var animation_player: AnimationPlayer = $AnimationPlayer

func open() -> void:
	animation_player.play("open")


func door_opened() -> void:
	emit_signal("opened")
