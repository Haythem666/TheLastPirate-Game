extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()

		player.max_health += 1
		player.health = min(player.health + 1, player.max_health)
		
		player.update_ui()

		queue_free()  # supprime le pickup
