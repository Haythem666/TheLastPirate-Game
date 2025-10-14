extends CanvasLayer

@onready var player_hearts = $PlayerHearts


func _ready() -> void:
	#GameManager.gained_coins.connect(update_coin_display)
	await get_tree().process_frame
	
	if GameManager.player:
		update_health_display(GameManager.player.health, GameManager.player.max_health)
	

#func update_coin_display(gained_coins):
#	$CoinDisplay.text = str(GameManager.coins)

func update_health_display(current_health: int, max_health: int):
	if player_hearts and player_hearts.has_method("update_hearts"):
		player_hearts.update_hearts(current_health, max_health)
