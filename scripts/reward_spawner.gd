extends Node

# Précharger les scènes

# Force de lancement
const LAUNCH_FORCE_MIN = 150.0
const LAUNCH_FORCE_MAX = 300.0
const LAUNCH_ANGLE_VARIATION = 60.0

static func spawn_coins(position: Vector2, count: int, parent: Node):
	var coin_scene = preload("res://scenes/coin.tscn")

	"""Spawner plusieurs pièces autour d'une position"""
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
		coin.setup_as_reward(position + spawn_offset, direction * force, 1)

static func spawn_diamonds(position: Vector2, count: int, parent: Node):
	"""Spawner des diamants (pièces de valeur 5)"""
	var diamond_scene = preload("res://scenes/coin.tscn")  # On utilisera la même avec valeur différente

	for i in range(count):
		var diamond = diamond_scene.instantiate()
		
		# Direction aléatoire
		var angle = randf_range(-LAUNCH_ANGLE_VARIATION, LAUNCH_ANGLE_VARIATION) - 90
		var direction = Vector2.from_angle(deg_to_rad(angle))
		var force = randf_range(LAUNCH_FORCE_MIN * 1.3, LAUNCH_FORCE_MAX * 1.3)
		
		var spawn_offset = Vector2(randf_range(-15, 15), randf_range(-10, 10))
		
		parent.add_child(diamond)
		
		# Diamant = valeur 5
		diamond.setup_as_reward(position + spawn_offset, direction * force, 5)
		
		# Changer le sprite pour un diamant bleu
		if diamond.has_node("Sprite2D"):
			var sprite = diamond.get_node("Sprite2D")
			sprite.texture = load("res://assets/Pirate Treasure/Sprites/Blue Diamond/01.png")
			sprite.modulate = Color(0.5, 0.8, 1.0)  # Teinte bleue

static func spawn_mixed_rewards(position: Vector2, coins: int, diamonds: int, parent: Node):
	"""Spawner un mélange"""
	spawn_coins(position, coins, parent)
	spawn_diamonds(position, diamonds, parent)
