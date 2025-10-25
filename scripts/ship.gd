extends CharacterBody2D

# Vitesses
@export var speed: float = 150.0
@export var acceleration: float = 5.0

# Flottement (oscillation)
@export var float_amplitude: float = 5.0  # hauteur du mouvement
@export var float_speed: float = 2.0      # vitesse de l’oscillation
var base_y: float = 0.0                   # position verticale de base
var float_timer: float = 0.0              # timer interne

# État
var is_player_near: bool = false
var is_player_on_board: bool = false
var player: Player = null
#var velocity: Vector2 = Vector2.ZERO

# Nodes
@onready var ship_sprite: Sprite2D = $Sprite2D
@onready var sail_sprite: Sprite2D = $SailSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea

func _ready():
	base_y = position.y
	
	# Connecter les signaux
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)
	
	# Animation idle par défaut
	animation_player.play("idle")

func _process(delta: float):
	# Afficher l'indicateur d'interaction
	if is_player_near and not is_player_on_board:
		show_interaction_prompt()
	
	# Monter/descendre du bateau
	if is_player_near and Input.is_action_just_pressed("attack"):
		if not is_player_on_board:
			board_ship()
		else:
			leave_ship()
	
	# Contrôler le bateau
	if is_player_on_board:
		control_ship(delta)
		
	float_timer += delta * float_speed
	position.y = base_y + sin(float_timer) * float_amplitude



func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_player_near = true
		player = area.get_parent()
		


func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_player_near = false
		if not is_player_on_board:
			player = null


func board_ship():
	if not player:
		return
	
	is_player_on_board = true
	
	# Désactiver le contrôle du joueur
	player.set_physics_process(false)
	player.visible = false
	
	# Position du joueur sur le bateau
	player.global_position = global_position
	

func leave_ship():
	if not player:
		return
	
	is_player_on_board = false
	
	# Réactiver le contrôle du joueur
	player.set_physics_process(true)
	player.visible = true
	
	# Téléporter le joueur à côté du bateau
	player.global_position = global_position + Vector2(80, 0)
	
	# Arrêter le bateau
	velocity = Vector2.ZERO
	animation_player.play("idle")
	
	print("Descendu du bateau!")

func control_ship(delta: float):
	var input_direction = Input.get_axis("left", "right")
	
	if input_direction != 0:
		# Accélérer
		velocity.x = lerp(velocity.x, input_direction * speed, acceleration * delta)
		
		# Orienter le bateau
		if input_direction > 0:
			ship_sprite.scale.x = abs(ship_sprite.scale.x)
			sail_sprite.scale.x = abs(sail_sprite.scale.x)
		else:
			ship_sprite.scale.x = -abs(ship_sprite.scale.x)
			sail_sprite.scale.x = -abs(sail_sprite.scale.x)
		
		# Animation de navigation
		if animation_player.current_animation != "sailing":
			animation_player.play("sailing")
	else:
		# Décélérer
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		
		# Retour à idle si presque arrêté
		if abs(velocity.x) < 10:
			velocity.x = 0
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
	
	# Déplacer le bateau
	#position += velocity * delta
	move_and_slide()	
	
	# Déplacer le joueur avec le bateau
	if player:
		player.global_position = global_position

func show_interaction_prompt():
	# TODO: Afficher un sprite ou label "Appuyer sur E"
	pass
