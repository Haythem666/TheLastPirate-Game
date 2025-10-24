extends Node

signal gained_coins(int)

var coins : int = 0

var current_checkpoint  : Checkpoint

var player : Player

var player_max_health : int = 3


func respawn_player():
	player.health = player.max_health
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	
	var ui_manager = get_tree().get_first_node_in_group("ui_manager")
	if ui_manager and ui_manager.has_method("update_health_display"):
		ui_manager.update_health_display(player.health, player.max_health)
	

func gain_coins(coins_gained: int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	#on peut utiliser coins_gained pour activer des trucs(un ennemi devient plis fort)

func save_player_health(max_health: int):
	player_max_health = max_health
