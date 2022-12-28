extends Enemy

const ThrowableKnifeScene: PackedScene =preload(
	"res://characters/enemy/goblin/ThrowableKnife.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 90
const MIN_DISTANCE_TO_PLAYER: int = 40

export(int) var projectile_speed: int = 150

var can_attack: bool = true
var distance_to_player: float

onready var attack_timer = $AttackTimer
onready var aim_raycast = $AimRayCast


func _physics_process(_delta: float) -> void:
	if weakref(player).get_ref():
		distance_to_player = (global_position - player.global_position).length()
	if nav_agent.is_target_reachable():
		move_direction = position.direction_to(nav_agent.get_next_location())


func chase() -> void:
	if weakref(player).get_ref():
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			nav_target = player.position
			nav_agent.set_target_location(nav_target)
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			nav_target = _get_retreat_target()
			nav_agent.set_target_location(nav_target)
		else:
			aim_raycast.cast_to = player.position - global_position
			if can_attack: #and !aim_raycast.is_colliding():
				can_attack = false
				_throw_knife()
				attack_timer.start()
		animated_sprite.flip_h = move_direction.x < 0


func _get_retreat_target() -> Vector2:
	var dir: Vector2 = (global_position - player.global_position).normalized()
	var target: Vector2 = (global_position + dir * 100)
	return target


func _throw_knife() -> void:
	var projectile: Area2D = ThrowableKnifeScene.instance()
	var throw_direction = (player.position - global_position).normalized()
	projectile.launch(global_position, throw_direction, projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _on_AttackTimer_timeout() -> void:
	can_attack = true
