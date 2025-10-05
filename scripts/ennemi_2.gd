extends CharacterBody2D


var SPEED = -60.0

var facing_right = false
var dead = false

var attacking = false

var max_health = 5
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
	


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead:
		area.get_parent().take_damage(1)

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

func hit():
	attacking=true
	$AttackDetector.monitoring=true
	$AttackDetector2.monitoring=true
	
func end_of_hit():
	attacking = false
	$AttackDetector.monitoring=false
	$AttackDetector2.monitoring=false
	$AnimationPlayer.play("run")

	
	


func _on_player_detector_body_entered(body: Node2D) -> void:
	if not attacking and not dead:

		attacking = true
		$AnimationPlayer.play("attack")
		
		
		$AttackDetector.monitoring = true
		$AttackDetector2.monitoring = true
		
		# attendre fin animation
		var attack_length = $AnimationPlayer.current_animation_length
		await get_tree().create_timer(attack_length).timeout
		end_of_hit()


func _on_player_detector_2_body_entered(body: Node2D) -> void:
	if not attacking and not dead:

		attacking = true
		$AnimationPlayer.play("attack")
		
		
		$AttackDetector.monitoring = true
		$AttackDetector2.monitoring = true
		# attendre fin animation
		var attack_length = $AnimationPlayer.current_animation_length
		await get_tree().create_timer(attack_length).timeout
		end_of_hit()


func _on_attack_detector_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_attack_detector_2_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
