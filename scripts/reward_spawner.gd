extends Node


# Force de lancement
const LAUNCH_FORCE_MIN = 150.0
const LAUNCH_FORCE_MAX = 300.0
const LAUNCH_ANGLE_VARIATION = 60.0

static func spawn_coins(position: Vector2, count: int, parent: Node):
	var coin_scene = preload("res://scenes/coin.tscn")

	for i in range(count):
		var coin = coin_scene.instantiate()
		
		# Direction aléatoire vers le haut
		var angle = randf_range(-LAUNCH_ANGLE_VARIATION, LAUNCH_ANGLE_VARIATION) - 90
		var direction = Vector2.from_angle(deg_to_rad(angle))
		var force = randf_range(LAUNCH_FORCE_MIN, LAUNCH_FORCE_MAX)
		
		# Petit décalage
		var spawn_offset = Vector2(randf_range(-10, 10), randf_range(-5, 5))
		
		# Ajouter au niveau
		parent.add_child(coin)
		
		# Configuration comme récompense (après l'ajout)
		coin.setup_as_reward(position + spawn_offset+Vector2(0, -30), direction * force, 1)

static func spawn_diamonds(position: Vector2, count: int, parent: Node):
	
	var coin_scene = preload("res://scenes/diamond.tscn")
	
	for i in range(count):
		var diamond = coin_scene.instantiate()
		
		# Direction aléatoire
		var angle = randf_range(-LAUNCH_ANGLE_VARIATION, LAUNCH_ANGLE_VARIATION) - 90
		var direction = Vector2.from_angle(deg_to_rad(angle))
		var force = randf_range(LAUNCH_FORCE_MIN * 1.3, LAUNCH_FORCE_MAX * 1.3)
		
		var spawn_offset = Vector2(randf_range(-15, 15), randf_range(-10, 10))
		
		parent.add_child(diamond)
		
		# Diamant = valeur 10
		diamond.setup_as_reward(position + spawn_offset+Vector2(0, -40), direction * force, 10)
		
		

static func spawn_mixed_rewards(position: Vector2, coins: int, diamonds: int, parent: Node):
	
	spawn_coins(position, coins, parent)
	spawn_diamonds(position, diamonds, parent)
