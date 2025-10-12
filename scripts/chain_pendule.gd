extends Node2D

# Configuration du pendule
@export var swing_angle: float = 60.0    # Angle max du pendule (en degrés)
@export var swing_speed: float = 1.5     # Vitesse du balancement

# Nodes
@onready var pivot: Node2D = $Pivot
@onready var chain_container: Node2D = $Pivot/ChainContainer
@onready var spike_ball: Area2D = $Pivot/SpikeBall

# Variables de mouvement
var time: float = 0.0
var initial_offset: float = 0.0  # Pour décaler le début du balancement

func _ready():
	# Connecter le signal de collision
	if spike_ball:
		spike_ball.area_entered.connect(_on_spike_ball_area_entered)
	
	# Offset aléatoire pour que chaque pendule soit différent
	initial_offset = randf() * TAU  # TAU = 2*PI

func _process(delta: float):
	time += delta
	
	# Calculer l'angle du pendule (mouvement sinusoïdal)
	var angle = deg_to_rad(swing_angle) * sin((time + initial_offset) * swing_speed)
	
	# Appliquer la rotation au Pivot
	pivot.rotation = angle


func _on_spike_ball_area_entered(area: Area2D):
	# Si la boule touche le joueur
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
		print("Spike ball a touché le joueur !")
