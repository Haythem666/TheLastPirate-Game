extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var run_sound: AudioStreamPlayer2D = $RunningSound
@onready var attack_sound: AudioStreamPlayer = $AttackSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var drown_sound: AudioStreamPlayer2D = $DrownSound


var unlocked_attacks: Array[ShopItem] = []
@export var has_dash: bool = false
var dash_speed: float = 400.0
var dash_duration: float = 0.2
var is_dashing: bool = false



var normal_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var drowning_gravity = 50  

@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -400.0

@export var attacking = false
@export var hit = false
@export var drowning = false

var max_health = 3
var health = 0
var can_take_damage = true


func _ready() -> void:
	health = max_health
	GameManager.player = self

	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") && !hit && !is_dashing:
		attack("attack",1)
	
	for unlocked in unlocked_attacks:
		if Input.is_action_just_pressed(unlocked.attack_input) && !hit && !is_dashing:
			attack(unlocked.attack_animation, unlocked.attack_damage)
	
	# Dash
	if has_dash and Input.is_action_just_pressed("ui_shift") and !is_dashing:
		perform_dash()
	
	# Toggle shop
	if Input.is_action_just_pressed("shop_toggle"):
		var shop = get_tree().get_first_node_in_group("shop_ui")
		if shop:
			shop.toggle_shop()

func _physics_process(delta: float) -> void:
	var gravity = drowning_gravity if drowning else normal_gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Flip du sprite selon la direction
	if Input.is_action_pressed("left"):
		sprite_2d.scale.x = -abs(sprite_2d.scale.x)
		$SwordEffect.scale.x= -abs($SwordEffect.scale.x) 
		$SwordEffect.position = Vector2(-30,0)
		$Area2D.scale.x = abs($Area2D.scale.x)* -1
		
	elif Input.is_action_pressed("right"):
		sprite_2d.scale.x = abs(sprite_2d.scale.x)
		$SwordEffect.scale.x= abs($SwordEffect.scale.x)
		$SwordEffect.position = Vector2(30,0)
		$Area2D.scale.x = abs($Area2D.scale.x)
		
	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Déplacement horizontal
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Applique le mouvement + collisions
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D :
			collider.linear_velocity.x = velocity.x * 1.5  # pousse la box


	# Update animation
	update_animation()
	
	if position.y >= 1000:
		die()

func attack(anim_name : String="attack", damage: int = 1):
	
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	#for area in overlapping_objects:
	#	var parent = area.get_parent()
	#	parent.queue_free()
	#parent.take_damage()
		#ici on vient de tuer le chest 
		
	for area in overlapping_objects:
		if area.get_parent().is_in_group("enemies"):
			area.get_parent().take_damage(damage)
			
	attacking=true
	animation_player.play(anim_name)
	attack_sound.play()

# Nouvelle fonction pour débloquer des attaques
func unlock_attack(item: ShopItem):
	unlocked_attacks.append(item)

# Nouvelle fonction pour le dash
func perform_dash():
	is_dashing = true
	var dash_direction = 1 if sprite_2d.scale.x > 0 else -1
	velocity.x = dash_speed * dash_direction
	
	# Animation ou effet visuel du dash
	modulate = Color(1, 1, 1, 0.5)  # Semi-transparent
	
	await get_tree().create_timer(dash_duration).timeout
	
	is_dashing = false
	modulate = Color(1, 1, 1, 1)  # Opaque
	
func start_drowning():
	drowning = true
	velocity.y *= 0.3
	drown_sound.play()
	animation_player.play("drown")  

func stop_drowning():
	drowning = false

func update_animation() -> void:
	if drowning:
		return
		
	if !attacking && !hit:
		if not is_on_floor():  # perso en l'air
			if velocity.y < 0:
				animation_player.play("jump")
				run_sound.stop()
			else:
				animation_player.play("fall")
				run_sound.stop()
		else:  # perso au sol
			if velocity.x != 0:
				animation_player.play("run")
				if !run_sound.playing:
					run_sound.play()
			else:
				animation_player.play("idle")
				run_sound.stop()
	   
			
func take_damage(damage_amount : int):
	if can_take_damage:
		iframes()
		
		hit = true
		attacking = false
		animation_player.play("hit")
		run_sound.stop()
		$HitSound.play()
		
		health -= damage_amount
		#var ui_manager = get_node("/root/Level1/UIManager")
		#ui_manager.update_health_display(health, max_health)
		
		if health <= 0:
			animation_player.play("dead")
			await get_tree().create_timer(0.5).timeout
			die()

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage= true

func die():
	attacking = false
	hit = false
	drowning = false
	velocity = Vector2.ZERO
	health = max_health
	GameManager.respawn_player()
