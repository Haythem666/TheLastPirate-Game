extends Node

signal gained_coins(int)

var coins : int

var current_checkpoint  : Checkpoint

var player : Player

func respawn_player():
	player.health = player.max_health
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	
	#var ui_manager = get_node("/root/Level1/UIManager")
	#ui_manager.update_health_display(player.health, player.max_health)

func gain_coins(coins_gained: int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	#on peut utiliser coins_gained pour activer des trucs(un ennemi devient plis fort)
