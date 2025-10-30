extends StaticBody2D

var wood_spike = preload("res://scenes/wood_spike.tscn")


@export var shooting: bool = true
@export var firerate: float = 2.0
@export var shoot_direction: float = 1.0  

# Nodes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var firepoint: Node2D = $Firepoint
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite: Sprite2D = $Sprite2D

var max_health: int = 3
var health: int = 0

func _ready():
	health = max_health

	shoot_timer.wait_time = firerate
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	if shooting:
		shoot_timer.start()
		shoot()

func _on_shoot_timer_timeout():
	if shooting:
		shoot()

func shoot():
	if animation_player.has_animation("attack"):
		animation_player.play("attack")
	else:
		fire()

func fire():
	var spike = wood_spike.instantiate()
	
	var spawn_pos = firepoint.global_position
	
	spike.setup(spawn_pos, shoot_direction)
	
	get_tree().root.add_child(spike)

func take_damage(damage_amount: int):
	
	health -= damage_amount
	$HealthBar.update_healthbar(health,max_health)
	
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
