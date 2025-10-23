extends CharacterBody2D

@onready var attack_detector: Area2D = $AttackDetector
@onready var attack_detector_4: Area2D = $AttackDetector4

@export var attack_push_speed: float = 200.0   # vitesse de la poussée
@export var attack_push_duration: float = 0.2  # durée de la poussée (en secondes)


var SPEED = -40.0

var facing_right = false
var dead = false

var attacking = false

var max_health = 10
var health

func _ready() -> void:
	health = max_health
	$AnimationPlayer.play("run")

func _physics_process(delta: float) -> void:
	if attacking or dead :
		velocity.x=0
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if !$RayCast2D.is_colliding() && is_on_floor():
			flip()
			
		if $WallRayCast.is_colliding():
			flip()
	
		velocity.x=SPEED
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x= abs(scale.x) * -1
	if facing_right:
		SPEED= abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1
	

func take_damage(damage_amount):
	health -= damage_amount
	
	$HealthBar.update_healthbar(health,max_health)
	$AnimationPlayer.play("hit")
	
	
	if health <= 0 :
		die()
	else:
		# Revenir à run après 0.3 sec
		await get_tree().create_timer(0.3).timeout
		if !dead:
			$AnimationPlayer.play("run")

func die():
	dead = true
	SPEED = 0
	$AnimationPlayer.play("die")
	
	var reward_spawner = load("res://scripts/reward_spawner.gd")
	reward_spawner.spawn_mixed_rewards(global_position,2,3,get_tree().root)

func hit():
	attacking=true
	attack_detector.monitoring=true
	
func end_of_hit():
	attacking = false
	attack_detector.monitoring=false
	$AnimationPlayer.play("run")

	
	


func _on_player_detector_body_entered(body: Node2D) -> void:
	if not attacking and not dead:

		attacking = true
		$AnimationPlayer.play("attack")
		
		
		attack_detector.monitoring = true
		attack_detector_4.monitoring=true
		
		var direction = 1 if facing_right else -1
		apply_attack_push(direction)

		# attendre fin animation
		var attack_length = $AnimationPlayer.current_animation_length
		await get_tree().create_timer(attack_length).timeout
		end_of_hit()
		

func _on_player_detector_2_body_entered(body: Node2D) -> void:
	if not attacking and not dead:

		attacking = true
		$AnimationPlayer.play("attack")
		
		
		attack_detector.monitoring = true
		attack_detector_4.monitoring=true
		
		var direction = 1 if facing_right else -1
		apply_attack_push(direction)

		
		# attendre fin animation
		var attack_length = $AnimationPlayer.current_animation_length
		await get_tree().create_timer(attack_length).timeout
		end_of_hit()





func _on_attack_detector_2_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_hitbox_2_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead:
		area.get_parent().take_damage(1)


func _on_attack_detector_4_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
	
func apply_attack_push(direction: int) -> void:
	var original_speed = SPEED
	SPEED = direction * attack_push_speed
	await get_tree().create_timer(attack_push_duration).timeout
	SPEED = original_speed
