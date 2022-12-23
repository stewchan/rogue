extends Area2D



func _on_HealthPotion_body_entered(player: KinematicBody2D) -> void:
	$CollisionShape2D.disabled = true
	player.hp += 1
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(self, "queue_free")
