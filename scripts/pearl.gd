
	
extends Area2D

var direction = 1
var speed = 200.0
var lifetime = 5.0
var hit = false 

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
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
	


func die():
	hit = true
	speed = 0 
	
	if animation_player.has_animation("hit"):
		animation_player.play("hit")
		await animation_player.animation_finished
	#
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !hit:
		area.get_parent().take_damage(1)
		die()
		
func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer or body is StaticBody2D:
		die()
