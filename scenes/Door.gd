extends StaticBody2D

signal opened

onready var animation_player: AnimationPlayer = $AnimationPlayer


func open() -> void:
	animation_player.play("open")


func finished_opening() -> void:
	emit_signal("opened")
