extends Node2D
#
#@export var platform_path: NodePath = "../PlateformS"
#@export var max_tilt_angle: float = 25.0  # en degrés
#@export var tilt_speed: float = 5.0       # vitesse d’inclinaison
#@export var player_path: NodePath = "../PlayerTest"  # chemin vers le joueur
#
#var platform: Node2D
#var player: Node2D
#
#func _ready():
	#platform = get_node(platform_path)
	#player = get_node(player_path)
#
#func _process(delta):
	#if not player:
		#return
#
	## Position relative du joueur sur la plateforme
	#var local_player_pos = platform.to_local(player.global_position)
	#var rel_x = clamp(local_player_pos.x / (platform.scale.x * 0.5), -1, 1)
#
	## Angle cible en radians
	#var target_angle = deg_to_rad(max_tilt_angle) * rel_x
#
	## Inclinaison fluide
	#platform.rotation = lerp(platform.rotation, target_angle, tilt_speed * delta)
