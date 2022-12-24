extends Area2D

signal stairs_entered


func _on_Stairs_body_entered(body: KinematicBody2D) -> void:
	if body is Player:
		emit_signal("stairs_entered")
