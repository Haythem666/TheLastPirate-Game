extends Area2D

var direction: float = 1.0  # 1 = droite, -1 = gauche
var speed: float = 200.0
var lifetime: float = 5.0
var hit: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Détruire après un certain temps
	await get_tree().create_timer(lifetime).timeout
	if is_instance_valid(self):
		queue_free()
	
	# Connexion des signaux
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	if not hit:
		# Déplacer le spike
		position.x += speed * delta * direction

func setup(spawn_position: Vector2, fire_direction: float):
	global_position = spawn_position
	direction = fire_direction
	
	# Orienter le sprite
	#if direction < 0:
		#sprite.flip_h = true

func _on_area_entered(area: Area2D):
	# Si touche le joueur
	if area.get_parent() is Player and not hit:
		area.get_parent().take_damage(1)
		die()

func _on_body_entered(body: Node2D):
	# Si touche un mur
	if body is TileMap or body is StaticBody2D:
		die()

func die():
	if hit:
		return
	
	hit = true
	speed = 0
	
	# Animation de destruction
	if animation_player.has_animation("destroyed"):
		animation_player.play("destroyed")
		await animation_player.animation_finished
	
	queue_free()
