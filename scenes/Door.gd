extends StaticBody2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite


func open() -> void:
	animated_sprite.play("opening")


func _on_AnimatedSprite_animation_finished() -> void:
	animated_sprite.play("fully_open")
	animated_sprite.stop()
	
