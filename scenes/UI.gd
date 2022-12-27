extends CanvasLayer

const MIN_HEALTH_OFFSET: int = 23

var max_hp: float = 4.0

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var health_bar: TextureProgress = $HealthBar


func _ready() -> void:
	max_hp = player.hp
	_update_health_bar(100)


func _update_health_bar(new_value: int) -> void:
	# TODO: use sceneTreeTween
	var tween = Tween.new()
	tween.interpolate_property(health_bar, "value", health_bar.value, new_value, 0.5,
		Tween.TRANS_QUINT, Tween.EASE_OUT)
	add_child(tween)
	tween.start()


func _on_Player_hp_changed(new_hp:int) -> void:
	var new_health: int = int((100 - MIN_HEALTH_OFFSET) * new_hp/max_hp) + MIN_HEALTH_OFFSET
	_update_health_bar(new_health)
