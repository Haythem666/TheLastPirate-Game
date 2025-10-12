extends CanvasLayer


@onready var grid_attacks = $Panel/VBoxContainer/TabContainer/ATTACKS/ScrollContainer/GridContainer
@onready var grid_abilities = $Panel/VBoxContainer/TabContainer/CAPACITY/ScrollContainer/GridContainer
@onready var grid_health = $Panel/VBoxContainer/TabContainer/HEALTH/ScrollContainer/GridContainer
@onready var coins_label = $Panel/VBoxContainer/Header/CoinsContainer/CoinsLabel
@onready var close_button = $Panel/VBoxContainer/Header/CloseButton

var item_card_scene = preload("res://scenes/shop_item_card.tscn")

func _ready():
	
	visible = false
	close_button.pressed.connect(_on_close_pressed)
	ShopManager.coins_updated.connect(_on_coins_updated)
	ShopManager.item_purchased.connect(_on_item_purchased)

func _input(event):
	if event.is_action_pressed("shop_toggle"):
		toggle_shop()

func toggle_shop():
	visible = !visible
	get_tree().paused = visible
	
	if visible:
		refresh_shop()

func refresh_shop():
	# Vider les grilles
	clear_grid(grid_attacks)
	clear_grid(grid_abilities)
	clear_grid(grid_health)
	
	# Remplir avec les items
	for item in ShopManager.get_available_items():
		var card = item_card_scene.instantiate()
		card.setup(item)
		card.purchase_requested.connect(_on_purchase_requested)
		
		match item.item_type:
			"attack":
				grid_attacks.add_child(card)
			"ability":
				grid_abilities.add_child(card)
			"health":
				grid_health.add_child(card)
	
	# Mettre à jour l'affichage des coins
	_on_coins_updated(GameManager.coins)

func clear_grid(grid: GridContainer):
	for child in grid.get_children():
		child.queue_free()

func _on_purchase_requested(item: ShopItem):
	
	if ShopManager.purchase_item(item):
		
		play_purchase_animation()
		refresh_shop()
	else:
		
		play_insufficient_funds_animation()

func _on_coins_updated(amount: int):
	coins_label.text = str(amount)

func _on_item_purchased(item: ShopItem):
	# Animation ou son de succès
	pass

func _on_close_pressed():
	toggle_shop()

func play_purchase_animation():
	# Animation de succès
	pass

func play_insufficient_funds_animation():
	# Animation de shake du label de coins
	pass
