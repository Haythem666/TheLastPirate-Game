extends StaticBody2D

# Précharger le projectile
var wood_spike = preload("res://scenes/wood_spike.tscn")

# Configuration
@export var shooting: bool = true
@export var firerate: float = 2.0
@export var shoot_direction: float = 1.0  # 1 = droite, -1 = gauche

# Nodes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var firepoint: Node2D = $Firepoint
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite: Sprite2D = $Sprite2D

# Santé (optionnel si tu veux qu'il soit destructible)
var max_health: int = 3
var health: int = 0

func _ready():
	health = max_health
	
	# Orienter le totem selon la direction
	#if shoot_direction < 0:
	#	sprite.flip_h = true
	#	firepoint.position.x = -abs(firepoint.position.x)
	
	# Configurer le timer
	shoot_timer.wait_time = firerate
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	if shooting:
		shoot_timer.start()
		# Première attaque immédiate
		shoot()

func _on_shoot_timer_timeout():
	if shooting:
		shoot()

func shoot():
	# Animation d'attaque
	if animation_player.has_animation("attack"):
		animation_player.play("attack")
	else:
		# Si pas d'animation, tirer directement
		fire()

func fire():
	# Créer le projectile
	var spike = wood_spike.instantiate()
	
	# Position de spawn (à la bouche du totem)
	var spawn_pos = firepoint.global_position
	
	# Configurer le spike
	spike.setup(spawn_pos, shoot_direction)
	
	# Ajouter au niveau
	get_tree().root.add_child(spike)

# Optionnel : Fonction pour prendre des dégâts
func take_damage(damage_amount: int):
	health -= damage_amount
	
	if animation_player.has_animation("hit"):
		animation_player.play("hit")
	
	if health <= 0:
		die()

func die():
	shooting = false
	shoot_timer.stop()
	
	if animation_player.has_animation("destroyed"):
		animation_player.play("destroyed")
		await animation_player.animation_finished
	
	queue_free()
