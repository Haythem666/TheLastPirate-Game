extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0


@export var attacking = false

var max_health = 2
var health = 0
var can_take_damage = true

func _ready() -> void:
	health= max_health
	GameManager.player = self
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Flip du sprite selon la direction
	if Input.is_action_pressed("left"):
		sprite_2d.scale.x = -abs(sprite_2d.scale.x)
		$Area2D.scale.x = abs($Area2D.scale.x)* -1
	elif Input.is_action_pressed("right"):
		sprite_2d.scale.x = abs(sprite_2d.scale.x)
		$Area2D.scale.x = abs($Area2D.scale.x)


	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Déplacement horizontal
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Applique le mouvement + collisions
	move_and_slide()

	# Update animation
	update_animation()
	
	if position.y >= 1000:
		die()

func attack():
	
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	#for area in overlapping_objects:
	#	var parent = area.get_parent()
	#	parent.queue_free()
	#parent.take_damage()
		#ici on vient de tuer le chest 
		
	for area in overlapping_objects:
		if area.get_parent().is_in_group("enemies"):
			area.get_parent().die()
			
	attacking=true
	animation_player.play("attack")
	

func update_animation() -> void:
	if !attacking:
		if not is_on_floor():  # perso en l'air
			if velocity.y < 0:
				animation_player.play("jump")
			else:
				animation_player.play("fall")
		else:  # perso au sol
			if velocity.x != 0:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	   
			

func die():
	GameManager.respawn_player()
