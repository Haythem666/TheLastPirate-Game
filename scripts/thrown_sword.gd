extends Area2D

@export var speed: float = 400.0
@export var lifetime: float = 3.0
@export var damage: int = 1

var direction: Vector2 = Vector2.RIGHT
var has_hit: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	# Lancer l'animation de rotation
	animation_player.play("spin")
	
	# Détruire après un certain temps
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
	# Connexion des signaux
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Détruire si sort de l'écran
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _physics_process(delta: float):
	if not has_hit:
		# Déplacer l'épée
		position += direction * speed * delta

func setup(launch_direction: Vector2, launch_position: Vector2):
	direction = launch_direction.normalized()
	global_position = launch_position
	
	# Orienter le sprite selon la direction
	rotation = direction.angle()
	

func _on_area_entered(area: Area2D):
	# Si l'épée touche un ennemi (via son Area2D)
	var parent = area.get_parent()
	if parent and parent.is_in_group("enemies") and not has_hit:
		parent.take_damage(damage)
		_hit_effect()


func _on_body_entered(body: Node2D):
	# Si l'épée touche un mur ou un objet solide
	if body is TileMap or body is StaticBody2D:
		_stick_to_wall()

func _hit_effect():
	has_hit = true
	speed = 0
	
	# Effet visuel (flash blanc)
	sprite_2d.modulate = Color(2, 2, 2, 1)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1, 1)
	
	# Disparaître
	queue_free()

func _stick_to_wall():
	has_hit = true
	speed = 0
	animation_player.stop()
	
	# Rester plantée dans le mur pendant 2 secondes
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _on_screen_exited():
	# Détruire si sort de l'écran
	queue_free()
