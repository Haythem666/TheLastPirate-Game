extends Node2D



#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.get_parent() is Player:
	#	area.get_parent().max_health += 1
	#	area.get_parent().health +=1
	#	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()

		# On augmente la vie mais pas au-delà de MAX_HEALTH
		player.health = min(player.health + 1, 3)
		player.max_health = min(player.max_health + 1,3)

		# Mettre à jour la barre de vie
		var ui_manager = get_node("/root/Level1/UIManager")
		ui_manager.update_health_display(player.health, player.max_health)

		queue_free()  # supprime le pickup
