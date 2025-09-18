extends CanvasLayer


#func _ready() -> void:
	#GameManager.gained_coins.connect(update_coin_display)
	
#func update_coin_display(gained_coins):
#	$CoinDisplay.text = str(GameManager.coins)

@onready var hearts = [$Hearts/Heart1,$Hearts/Heart2,$Hearts/Heart3]  # récupère les 3 TextureRect

func _ready() -> void:
	GameManager.gained_coins.connect(update_coin_display)

func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManager.coins)

# Met à jour les cœurs
func update_health_display(current_health: int, max_health: int):
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].visible = true   # cœur plein
		else:
			hearts[i].visible = false  # cœur vide / disparu
