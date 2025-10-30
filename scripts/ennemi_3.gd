extends CharacterBody2D

@export var attack_push_speed: float = 300.0
@export var attack_push_duration: float = 0.5

var SPEED = -60.0
var facing_right = false
var dead = false
var attacking = false
var is_pushing = false

var max_health = 10
var health

func _ready() -> void:
	health = max_health
	$AnimationPlayer.play("run")

func _physics_process(delta: float) -> void:
	if (attacking and not is_pushing) or dead:
		velocity.x = 0
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if not attacking:
			if !$RayCast2D.is_colliding() && is_on_floor():
				flip()
			
			if $WallRayCast.is_colliding():
				flip()
		
		velocity.x = SPEED
	
	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1

func take_damage(damage_amount):
	health -= damage_amount
	$HealthBar.update_healthbar(health, max_health)
	$AnimationPlayer.play("hit")
	
	if health <= 0:
		die()
	else:
		await get_tree().create_timer(0.3).timeout
		if !dead and !attacking:
			$AnimationPlayer.play("run")

func die():
	dead = true
	SPEED = 0
	$AnimationPlayer.play("die")
	
	var reward_spawner = load("res://scripts/reward_spawner.gd")
	reward_spawner.spawn_mixed_rewards(global_position, 5, 1, get_tree().root)

func apply_attack_push():
	is_pushing = true
	var original_speed = SPEED
	
	if SPEED < 0:
		SPEED = -attack_push_speed
	else:
		SPEED = attack_push_speed
	
	await get_tree().create_timer(attack_push_duration).timeout
	
	SPEED = original_speed
	is_pushing = false

func start_attack():
	if attacking or dead:
		return
	
	attacking = true
	$AnimationPlayer.play("attack")
	$AttackDetector2.monitoring = true
	
	apply_attack_push()
	
	var attack_length = $AnimationPlayer.current_animation_length
	await get_tree().create_timer(attack_length).timeout
	end_of_hit()

func end_of_hit():
	attacking = false
	is_pushing = false
	
	$AttackDetector2.monitoring = false
	
	if !dead:
		$AnimationPlayer.play("run")

func _on_hitbox_2_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and !dead:
		area.get_parent().take_damage(1)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		start_attack()

func _on_attack_detector_2_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(2)
