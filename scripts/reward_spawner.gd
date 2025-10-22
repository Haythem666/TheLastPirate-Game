#extends Node
#
## Précharger les scènes de récompenses
#var coin_scene = preload("res://scenes/coin_reward.tscn")
#var diamond_scene = preload("res://scenes/diamond_reward.tscn")
#
## Force de lancement des récompenses
#const LAUNCH_FORCE_MIN = 150.0
#const LAUNCH_FORCE_MAX = 300.0
#const LAUNCH_ANGLE_VARIATION = 60.0  # Variation d'angle en degrés
#
#static func spawn_coins(position: Vector2, count: int, parent: Node):
	#"""Spawner plusieurs pièces autour d'une position"""
	#for i in range(count):
		#var coin = coin_scene.instantiate()
		#
		## Calculer une direction aléatoire vers le haut
		#var angle = randf_range(-LAUNCH_ANGLE_VARIATION, LAUNCH_ANGLE_VARIATION) - 90  # -90 pour partir vers le haut
		#var direction = Vector2.from_angle(deg_to_rad(angle))
		#var force = randf_range(LAUNCH_FORCE_MIN, LAUNCH_FORCE_MAX)
		#
		## Petit décalage de position pour éviter le chevauchement
		#var spawn_offset = Vector2(randf_range(-10, 10), randf_range(-5, 5))
		#
		## Ajouter au niveau
		#parent.add_child(coin)
		#
		## Setup après l'ajout pour que global_position fonctionne
		#coin.setup(position + spawn_offset, direction * force)
#
#static func spawn_diamonds(position: Vector2, count: int, parent: Node):
	#"""Spawner plusieurs diamants autour d'une position"""
	#for i in range(count):
		#var diamond = diamond_scene.instantiate()
		#
		## Direction aléatoire
		#var angle = randf_range(-LAUNCH_ANGLE_VARIATION, LAUNCH_ANGLE_VARIATION) - 90
		#var direction = Vector2.from_angle(deg_to_rad(angle))
		#var force = randf_range(LAUNCH_FORCE_MIN * 1.2, LAUNCH_FORCE_MAX * 1.2)  # Plus de force
		#
		#var spawn_offset = Vector2(randf_range(-15, 15), randf_range(-10, 10))
		#
		#parent.add_child(diamond)
		#diamond.setup(position + spawn_offset, direction * force)
#
#static func spawn_mixed_rewards(position: Vector2, coins: int, diamonds: int, parent: Node):
	#"""Spawner un mélange de pièces et diamants"""
	#spawn_coins(position, coins, parent)
	#spawn_diamonds(position, diamonds, parent)
