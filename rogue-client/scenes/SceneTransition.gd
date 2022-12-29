extends CanvasLayer

var new_scene: String

onready var animation_player = $AnimationPlayer


func _ready() -> void:
	animation_player.play("change_scene")


func change_scene() -> void:
	print("Scene transition complete")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
