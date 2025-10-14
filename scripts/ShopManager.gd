extends Node

signal item_purchased(item: ShopItem)
signal coins_updated(amount: int)

var available_items: Array[ShopItem] = []
var purchased_items: Array[ShopItem] = []

func _ready():
	load_shop_items()
	
func load_shop_items():
	
	# Attaque rapide
	var quick_attack = ShopItem.new()
	quick_attack.id = "quick_attack"
	quick_attack.name = "Attaque Rapide"
	quick_attack.description = "Une attaque rapide qui inflige moins de dégâts mais est plus véloce"
	quick_attack.price = 50
	quick_attack.item_type = "attack"
	quick_attack.attack_animation = "quick_attack"
	quick_attack.attack_damage = 1
	quick_attack.icon = load("res://assets/sprites/MainPerso/15-Attack 1/Attack 1 02.png")
	quick_attack.attack_input = "quick_attack"
	available_items.append(quick_attack)
	
	# Attaque lourde
	var heavy_attack = ShopItem.new()
	heavy_attack.id = "heavy_attack"
	heavy_attack.name = "Attaque Lourde"
	heavy_attack.description = "Une attaque puissante qui inflige 2x les dégâts"
	heavy_attack.price = 100
	heavy_attack.item_type = "attack"
	heavy_attack.attack_animation = "heavy_attack"
	heavy_attack.icon= load("res://assets/sprites/MainPerso/17-Attack 3/Attack 3 02.png")
	heavy_attack.attack_damage = 2
	heavy_attack.attack_input = "attack3"
	available_items.append(heavy_attack)
	
	var throw_sword = ShopItem.new()
	throw_sword.id = "throw_sword"
	throw_sword.name = "Lancer d'Épée"
	throw_sword.description = "Lance ton épée qui traverse les ennemis"
	throw_sword.price = 150
	throw_sword.item_type = "ability"
	throw_sword.attack_animation = "thrown_sword"
	throw_sword.icon = load("res://assets/sprites/MainPerso/Sword/22-Sword Spinning/Sword Spinning 01.png")
	throw_sword.attack_damage = 3
	#throw_sword.attack_input="attack"
	available_items.append(throw_sword)
	
	# Vie supplémentaire
	var extra_health = ShopItem.new()
	extra_health.id = "extra_health"
	extra_health.name = "+1 Health"
	extra_health.description = "Gain 1 health"
	extra_health.price = 75
	extra_health.item_type = "health"
	extra_health.icon= load("res://assets/sprites/Objects/heartIdle.png")
	available_items.append(extra_health)
	
	# Dash
	var dash = ShopItem.new()
	dash.id = "dash"
	dash.name = "Dash"
	dash.description = "You can dash using Shift"
	dash.price = 80
	dash.item_type = "ability"
	dash.icon= load("res://assets/sprites/MainPerso/14-Hit Sword/Hit Sword 01.png")
	available_items.append(dash)
	
	

func can_purchase(item: ShopItem) -> bool:
	return GameManager.coins >= item.price and not item.is_purchased

func purchase_item(item: ShopItem) -> bool:
	if not can_purchase(item):
		return false
	
	GameManager.coins -= item.price
	item.is_purchased = true
	purchased_items.append(item)
	
	# Appliquer l'effet de l'item
	apply_item_effect(item)
	
	emit_signal("item_purchased", item)
	emit_signal("coins_updated", GameManager.coins)
	
	return true

func apply_item_effect(item: ShopItem):
	var player = GameManager.player
	
	match item.item_type:
		"attack":
			# Ajouter l'attaque au joueur
			player.unlock_attack(item)
		"health":
			player.max_health += 1
			player.health = player.max_health
			player.update_ui()

		"ability":
			if item.id == "dash":
				player.has_dash = true
			elif item.id == "throw_sword":  
				player.can_throw_sword = true

func get_available_items() -> Array[ShopItem]:
	return available_items

func get_purchased_items() -> Array[ShopItem]:
	return purchased_items
