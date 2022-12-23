extends CanvasLayer

var new_scene: String

onready var animation_player = $AnimationPlayer


func _ready() -> void:
	animation_player.play("change_scene")


func change_scene() -> void:
	print("Changed scenes")
