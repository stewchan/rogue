extends Area2D

signal descend
signal ascend

var going_down: bool = true
	

func _on_Stairs_body_entered(body: KinematicBody2D) -> void:
	if body is Player:
		if going_down:
			emit_signal("descend")
		else:
			emit_signal("ascend")
