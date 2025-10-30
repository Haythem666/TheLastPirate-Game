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
var dash_speed: float = 1200.0
var dash_duration: float = 0.5
var is_dashing: bool = false
var has_chest_key: bool = false


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

# sword
var thrown_sword_scene = preload("res://scenes/thrown_sword.tscn")
var can_throw_sword: bool = false 


func _ready() -> void:
	max_health = GameManager.player_max_health


	health = max_health
	GameManager.player = self
	
	_load_purchased_items()

	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") && !hit && !is_dashing:
		attack("attack",1)
	
	for unlocked in unlocked_attacks:
		if Input.is_action_just_pressed(unlocked.attack_input) && !hit && !is_dashing:
			attack(unlocked.attack_animation, unlocked.attack_damage)
	
	# Dash
	if has_dash and Input.is_action_just_pressed("dash") and !is_dashing:
		perform_dash()
	
	# Toggle shop
	if Input.is_action_just_pressed("shop_toggle"):
		var shop = get_tree().get_first_node_in_group("shop_ui")
		if shop:
			shop.toggle_shop()
	
	if Input.is_action_just_pressed("throw_sword") && !hit && !is_dashing && can_throw_sword:
		attack("throw_sword", 0)

func _physics_process(delta: float) -> void:
	var gravity = drowning_gravity if drowning else normal_gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	
	if Input.is_action_pressed("left"):
		sprite_2d.scale.x = -abs(sprite_2d.scale.x)
		$SwordEffect.scale.x= -abs($SwordEffect.scale.x) 
		$SwordEffect.position = Vector2(-30,0)
		$Area2D.scale.x = abs($Area2D.scale.x)* -1
		
		$AttackArea.scale.x = -abs($AttackArea.scale.x)
		$AttackArea.position.x = -abs($AttackArea.position.x)
		
	elif Input.is_action_pressed("right"):
		sprite_2d.scale.x = abs(sprite_2d.scale.x)
		$SwordEffect.scale.x= abs($SwordEffect.scale.x)
		$SwordEffect.position = Vector2(30,0)
		$Area2D.scale.x = abs($Area2D.scale.x)
		$AttackArea.scale.x = abs($AttackArea.scale.x)
		$AttackArea.position.x = abs($AttackArea.position.x)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#to push the box
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D :
			collider.linear_velocity.x = velocity.x * 1.2 


	update_animation()
	
	if position.y >= 1000:
		die()

func attack(anim_name : String="attack", damage: int = 1):
	
	var overlapping_objects = $AttackArea.get_overlapping_areas()
		
	for area in overlapping_objects:
		if area.get_parent().is_in_group("enemies"):
			area.get_parent().take_damage(damage)
			
	attacking=true
	animation_player.play(anim_name)
	attack_sound.play()

func unlock_attack(item: ShopItem):
	unlocked_attacks.append(item)

func perform_dash():
	is_dashing = true
	var dash_direction = 1 if sprite_2d.scale.x > 0 else -1
	velocity.x = dash_speed * dash_direction
	
	modulate = Color(1, 1, 1, 0.5)  
	
	await get_tree().create_timer(dash_duration).timeout
	
	is_dashing = false
	modulate = Color(1, 1, 1, 1)  
	
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
		if not is_on_floor(): 
			if velocity.y < 0:
				animation_player.play("jump")
				run_sound.stop()
			else:
				animation_player.play("fall")
				run_sound.stop()
		else:  
			if velocity.x != 0:
				animation_player.play("run")
				if !run_sound.playing:
					run_sound.play()
			else:
				animation_player.play("idle")
				run_sound.stop()
	   
			
func take_damage(damage_amount : int):
	if can_take_damage and !is_dashing:
		iframes()
		
		hit = true
		attacking = false
		animation_player.play("hit")
		run_sound.stop()
		$HitSound.play()
		
		health -= damage_amount
		update_ui()
		
		
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
	update_ui()
	
func throw_sword_projectile():
	if not can_throw_sword:
		return
	
	var sword = thrown_sword_scene.instantiate()
	
	var spawn_offset = Vector2(30, 0) if sprite_2d.scale.x > 0 else Vector2(-30, 0)
	var spawn_position = global_position + spawn_offset
	
	var throw_direction = Vector2.RIGHT if sprite_2d.scale.x > 0 else Vector2.LEFT
	
	sword.setup(throw_direction, spawn_position)
	
	get_tree().root.add_child(sword)
	
	
func update_ui():
	
	GameManager.save_player_health(max_health)

	var ui_manager = get_tree().get_first_node_in_group("ui_manager")
	if ui_manager and ui_manager.has_method("update_health_display"):
		ui_manager.update_health_display(health, max_health)


func _load_purchased_items():
	unlocked_attacks.clear()
	for item in ShopManager.get_purchased_items():
		match item.item_type:
			"attack":
				unlocked_attacks.append(item)
			"ability":
				if item.id == "dash":
					has_dash = true
				elif item.id == "throw_sword":
					can_throw_sword = true
			"health":
				pass
