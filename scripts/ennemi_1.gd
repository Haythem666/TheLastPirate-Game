extends CharacterBody2D

@onready var hit_sound: AudioStreamPlayer2D = $HitSound

var SPEED = -60.0

var facing_right = false
var dead = false

var max_health = 2
var health

func _ready() -> void:
	health = max_health
	$AnimationPlayer.play("run")

func _physics_process(delta: float) -> void:
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
	
	$AnimationPlayer.play("hit")
	$HitSound.play()
	$HealthBar.update_healthbar(health,max_health)

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
	$HitSound.play()
	$AnimationPlayer.play("die")
