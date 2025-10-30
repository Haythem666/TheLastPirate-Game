extends StaticBody2D

var canon_ball = load("res://scenes/canon_ball.tscn")
var debris = load("res://scenes/canon_debris.tscn")


@export var shooting: bool
var firerate = 2

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $Firepoint

var maxHealth = 3
var health 

func _ready() -> void:
	health = maxHealth
	shooting = true
	shoot()
	
func shoot():
	while shooting:
		animation_player.play("fire")
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_ball = canon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)

func take_damage(damage_amount):
	health -= damage_amount
	$HealthBar.update_healthbar(health,maxHealth)
	
	animation_player.play("hit")
	if health <= 0:
		die()

func die():
	var spawned_debris= debris.instantiate()
	spawned_debris.global_position = position + Vector2(0, 8)
	spawned_debris.get_child(1).play("crumble")
	get_parent().add_child(spawned_debris)
	
	queue_free()
